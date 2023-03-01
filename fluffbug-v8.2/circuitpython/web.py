import wifi
import socketpool
import time
import asyncio

from adafruit_httpserver import server, response
import settings


TICK = 0.25


http = server.HTTPServer(socketpool.SocketPool(wifi.radio))
gait = None


@http.route('/')
def index(request):
    with response.HTTPResponse(request) as r:
        r.send_file("static/index.html")

@http.route('/s')
def s(request):
    gait.command = 's'

@http.route('/f')
def f(request):
    gait.command = 'f'

@http.route('/l')
def l(request):
    gait.command = 'l'

@http.route('/r')
def r(request):
    gait.command = 'r'

async def serve(walk):
    global gait
    gait = walk
    name = settings.NET_NAME
    password = settings.NET_PASS
    wifi.radio.tx_power = 5
    wifi.radio.start_ap(name, password)
    address = str(wifi.radio.ipv4_address_ap)
    http.start(address, port=80, root_path='/static/')
    while True:
        http.poll()
        await asyncio.sleep(TICK)
