import flask 
import socket
import time
import random

h_name = socket.gethostname()
IP_addres = socket.gethostbyname(h_name)
app = flask.Flask(__name__)

@app.route('/')
def index():
    host = IP_addres
    client_ip = flask.request.remote_addr
    client_port = str(flask.request.environ.get('REMOTE_PORT'))
    hostname = h_name
    Time= time.strftime("%H:%M:%S")
    rand=str(random.randint(0,100))
    return Time+" "+client_ip + ":" +client_port +" -- " + host+" ("+hostname+") " +rand+"\n"



