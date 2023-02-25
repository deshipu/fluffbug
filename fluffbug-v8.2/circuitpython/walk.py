import robot
import asyncio


HEIGHT = 20
NEXT_LEG = (2, 3, 1, 0)
TICK = 0.04
LEG_TILT = (1, -1, 1, -1)


class Walk:
    def __init__(self):
        self.on_ground = set(robot.LEGS)
        self.speed_left = 2.5
        self.speed_right = 2.5
        self.command = None

    def do_command(self):
        if self.command is None:
            return
        elif self.command == 'f':
            self.speed_left = 2.5
            self.speed_right = 2.5
        elif self.command == 's':
            self.speed_left = 0
            self.speed_right = 0
        elif self.command == 'r':
            self.speed_left = -1
            self.speed_right = 1
        elif self.command == 'l':
            self.speed_left = 1
            self.speed_right = -1
        self.command = None

    async def init(self):
        for leg in robot.LEGS:
            leg.move(y=HEIGHT)
            await asyncio.sleep(TICK)

    async def slide(self):
        while True:
            stop = False
            for leg in self.on_ground:
                if leg.x > 40:
                    stop = True
                    break
            if not stop:
                for leg in self.on_ground:
                    try:
                        if leg.left:
                            leg.move(dx=self.speed_left)
                        else:
                            leg.move(dx=self.speed_right)
                    except ValueError:
                        break
            await asyncio.sleep(TICK)

    async def do_tilt(self, tilt):
        tilt = tilt * 3
        for step in range(0, 3):
            try:
                robot.LEGS[0].move(y=HEIGHT + tilt * step)
                robot.LEGS[1].move(y=HEIGHT - tilt * step)
                robot.LEGS[2].move(y=HEIGHT + tilt * step)
                robot.LEGS[3].move(y=HEIGHT - tilt * step)
            except ValueError:
                break
            await asyncio.sleep(TICK)

    async def do_step(self, leg):
        speed = self.speed_left if leg.left else self.speed_right
        leg.move(dy=10)
        self.on_ground.discard(leg)
        await asyncio.sleep(TICK)
        leg.move(dy=10)
        await asyncio.sleep(TICK)
        leg.move(x=speed * 6)
        await asyncio.sleep(TICK)
        leg.move(x=0)
        await asyncio.sleep(TICK)
        leg.move(x=-speed * 12)
        await asyncio.sleep(TICK)
        leg.move(x=-speed * 16)
        await asyncio.sleep(TICK)
        await asyncio.sleep(TICK)
        leg.move(dy=-20)
        await asyncio.sleep(TICK)
        self.on_ground.add(leg)

    async def creep(self):
        leg_number = 0
        tilt = -LEG_TILT[leg_number]
        while True:
            prev_tilt = tilt
            self.do_command()
            if self.speed_left == 0 and self.speed_right == 0:
                tilt = 0
                if tilt != prev_tilt:
                    await self.do_tilt(tilt)
                await asyncio.sleep(TICK)
                continue
            leg_number = NEXT_LEG[leg_number]
            leg = robot.LEGS[leg_number]
            tilt = -LEG_TILT[leg_number]
            if tilt != prev_tilt:
                await self.do_tilt(tilt)
            await self.do_step(leg)

    async def walk(self):
        await self.init()
        creep_task = asyncio.create_task(self.creep())
        slide_task = asyncio.create_task(self.slide())
        await asyncio.gather(creep_task, slide_task)
