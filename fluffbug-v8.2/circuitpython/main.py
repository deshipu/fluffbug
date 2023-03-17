import robot
import asyncio
import time
import walk
import web
import board
import digitalio


def calibrate():
    led = digitalio.DigitalInOut(board.LED)
    led.switch_to_output(value=0)
    for leg in robot.LEGS:
        leg.move()
        led.value = not led.value
        time.sleep(0.25)
    led.value = True
    while True:
        time.sleep(1)


async def main():
    gait = walk.Walk()
    walk_task = asyncio.create_task(gait.walk())
    web_task = asyncio.create_task(web.serve(gait))
    await asyncio.gather(walk_task)


#calibrate()

asyncio.run(main())
