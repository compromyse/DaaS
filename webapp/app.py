from crypt import methods
from flask import Flask, make_response, render_template, redirect, url_for, request
import base64
from contextlib import closing
import socket
import os

app = Flask(__name__)

users = {}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] not in users.keys() or users[str(request.form['username'])] != str(request.form['password']) :
            error = 'Invalid Credentials. Please try again.'
        else:
            resp = make_response()
            resp.set_cookie("isadmin", "MQ==")
            resp.headers['location'] = url_for('dashboard')
            return resp, 302
    return render_template('login.html', error=error)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    msg = None
    if request.method == 'POST':
        users[request.form['username']] = request.form['password']
        msg = "Done"
    return render_template('signup.html', msg=msg)

@app.route('/dashboard')
def dashboard():
    isadmin = None
    try:
        isadmin = base64.b64decode(request.cookies.get('isadmin')).decode("UTF-8")
    except:
        pass
    if isadmin == str(1):
        return render_template('dashboard.html')
    return render_template('error.html')

def find_free_port():
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]

@app.route('/create_container', methods=["POST"])
def container():
    freeport = find_free_port()
    command = f"bash -c \"ncat -lnp {freeport} --exec './docker.sh {request.form['container']}' & disown\""
    os.system(command)
    return render_template("dashboard.html", port=freeport)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=1337)
