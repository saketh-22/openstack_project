import flask
import time
import socket

h_name = socket.gethostname()
IP_addres = socket.gethostbyname(h_name)

app = flask.Flask(__name__)

@app.route('/')
def index():
    Time= time.strftime("%H:%M:%S")
    return Time+" Serving from "+h_name+" ("+IP_addres+")\n"
