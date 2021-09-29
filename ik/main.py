import board
import pwmio
import time
import math


PI2 = 1.57079
FEMUR = const(40)
TIBIA = const(50)
FEMUR2 = FEMUR * FEMUR
TIBIA2 = TIBIA * TIBIA
LENGTH2 = (TIBIA + FEMUR) * (TIBIA + FEMUR)


class Leg:
    def __init__(self, hip_pin, hip_trim, knee_pin, knee_trim, reverse, hind):
        self.hip_pwm = pwmio.PWMOut(hip_pin, frequency=50)
        self.knee_pwm = pwmio.PWMOut(knee_pin, frequency=50)
        self.sign = -1 if reverse else 1
        self.hip_trim = hip_trim
        self.knee_trim = knee_trim
        self.hind = hind
        self.x = 0
        self.y = 0

    def off(self):
        self.hip_pin.duty_cycle = 0
        self.knee_pin.duty_cycle = 0

    def move(self, x=None, y=None, dx=0, dy=0):
        if x is None:
            x = self.x
        if y is None:
            y = self.y
        x += dx
        y += dy
        self.x = x
        self.y = y

        if self.hind:
            x = FEMUR + x
        else:
            x = FEMUR - x
        y = TIBIA - y

        leg_length2 = x * x + y * y
        leg_length = math.sqrt(leg_length2)

        if leg_length2 > LENGTH2:
            raise ValueError("Out of reach")

        hip_leg_angle = math.acos(
            (FEMUR2 + leg_length2 - TIBIA2) /
            (2 * FEMUR * leg_length)
        )
        knee_angle = PI2 - math.acos(
            (FEMUR2 + TIBIA2 - leg_length2) /
            (2 * FEMUR * TIBIA)
        )
        hip_base_angle = math.atan2(y, x)
        self.angles(hip_base_angle - hip_leg_angle, knee_angle)

    def angles(self, hip_angle, knee_angle):
        if not -PI2 < hip_angle < PI2 or not -PI2 < knee_angle < PI2:
            raise ValueError("Bad angle")
        self.hip_pwm.duty_cycle = (self.hip_trim +
                                   int(1980 * hip_angle) * self.sign)
        self.knee_pwm.duty_cycle = (self.knee_trim +
                                    int(1980 * knee_angle) * self.sign)


LEGS = (
    Leg(board.A4, 4915 + 300, board.A3, 4915 + 100, False, True), # hind right
    Leg(board.TX, 4915 + 300, board.D5, 4915 + 100, True, True), # hind left
    Leg(board.A1, 4915 + 100, board.D6, 4915 + 200, True, False), # front right
    Leg(board.A6, 4915 + 300, board.RX, 4915 + 200, False, False), # front left
)


for leg in LEGS:
    leg.move()
    time.sleep(0.25)
while True:
    time.sleep(1)

for h in range(0, 20):
    for leg in LEGS:
        leg.move(h, 0)
    time.sleep(0.25)
for h in range(20, 0, -1):
    for leg in LEGS:
        leg.move(h, 0)
    time.sleep(0.25)

while True:
    time.sleep(1)
