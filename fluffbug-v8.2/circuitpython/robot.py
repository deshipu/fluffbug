import board
import pwmio
import math
import settings


PI2 = 1.57079
FEMUR = const(40)
TIBIA = const(50)
FEMUR2 = FEMUR * FEMUR
TIBIA2 = TIBIA * TIBIA
LENGTH2 = (TIBIA + FEMUR) * (TIBIA + FEMUR)


class Servo:
    def __init__(self, pin, center=6200):
        self.pwm = pwmio.PWMOut(pin, frequency=60)
        if center >= 0:
            self.center = center
            self.reverse = False
        else:
            self.center = -center
            self.reverse = True

    def move(self, radians):
        if self.reverse:
            radians = -radians
        # Compensate for the asymmetry in the servo motion.
        if radians > 0:
            us_per_radian = 2300
        else:
            us_per_radian = 2600
        self.pwm.duty_cycle = self.center + int(radians * us_per_radian)

    def off(self):
        self.pwm.duty_cycle = 0


class Leg:
    def __init__(self, hip, knee, hind, left):
        self.hip = hip
        self.knee = knee
        self.hind = hind
        self.left = left
        self.x = 0
        self.y = 0

    def off(self):
        self.hip.off()
        self.knee.off()

    def ik(self, x, y):
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
        if math.isnan(hip_leg_angle) or math.isnan(knee_angle):
            raise ValueError("Bad angle")
        return hip_base_angle - hip_leg_angle, knee_angle

    def move(self, x=None, y=None, dx=0, dy=0):
        if x is None:
            x = self.x
        if y is None:
            y = self.y
        x += dx
        y += dy
        hip, knee = self.ik(x, y)
        self.angles(hip, knee)
        self.x = x
        self.y = y

    def angles(self, hip_angle, knee_angle):
        self.hip.move(hip_angle)
        self.knee.move(knee_angle)

#C = 4915 # for 50Hz
C = 6200 # for 60Hz
LEGS = (
    Leg(Servo(board.IO1, C + settings.HIND_RIGHT_HIP),
        Servo(board.IO4, C + settings.HIND_RIGHT_KNEE),
        True, False),
    Leg(Servo(board.IO14, -C + settings.HIND_LEFT_HIP),
        Servo(board.IO10, -C + settings.HIND_LEFT_KNEE),
        True, True),
    Leg(Servo(board.IO2, -C + settings.FRONT_RIGHT_HIP),
        Servo(board.IO6, -C + settings.FRONT_RIGHT_KNEE),
        False, False),
    Leg(Servo(board.IO13, C + settings.FRONT_LEFT_HIP),
        Servo(board.IO8, C + settings.FRONT_LEFT_KNEE),
        False, True),
)
