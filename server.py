import sys
reload(sys)
sys.setdefaultencoding("UTF8")
import os
import uuid
from flask import Flask, session, request, redirect, url_for
from flask.ext.socketio import SocketIO, emit
import psycopg2
import psycopg2.extras
from datetime import datetime

app = Flask(__name__, static_url_path='')
app.secret_key = os.urandom(24).encode('hex')

socketio = SocketIO(app)


def connectToDB():
  connectionString = 'dbname=socketio user=ircclient password=X7pjgd27 host=localhost'
  print connectionString
  try:
    return psycopg2.connect(connectionString);
  except:
    print("Can't connect to database")

users = {}
isLoggedIn = ''

def updateRoster():
    names = []
    for user_id in users:
        print users[user_id]['username']
        names.append(users[user_id]['username'])
    print users
    print 'broadcasting names'
    emit('roster', names, broadcast=True)
    
@socketio.on('connect', namespace='/chat')
def test_connect():
    session['uuid'] = uuid.uuid1()
    print 'connected'
        
@socketio.on('message', namespace='/chat')
def new_message(message):
    
    username = users[session['uuid']]['username']
    messages = []
    tmp = {'text':message, 'name':users[session['uuid']]['username']}
    messages.append(tmp)
    username = users[session['uuid']]['username']

    emit('message', tmp, broadcast=True)
    
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    print 'connected to db for inserting message'
    
    user_select = "SELECT user_id FROM users WHERE username = %s"
    cur.execute(user_select, (username,))
    userId = cur.fetchone()

    try:
        insert_message = "INSERT INTO messages (message, user_id) VALUES (%s, %s);"
        data = (message, userId[0])
        cur.execute(insert_message, data)
    except:
        print("ERROR inserting into messages")
        conn.rollback()
    conn.commit()
        
    

@socketio.on('identify', namespace='/chat')
def on_identify(name):
    print ('identify' + name)
    users[session['uuid']] = {'username': name}


@socketio.on('check', namespace='/chat')
def checking(pw):
    
    username = users[session['uuid']]['username']
    
    #connect to database
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    print 'connected to db for messages'
        
    check_user = "SELECT user_id FROM users WHERE username = %s AND password = crypt(%s, password)"
    data = (username, pw)
    cur.execute(check_user, data)
    
    if cur.fetchone():
        
        loggedin = True
        
        session['isLoggedIn'] = username
        
        updateRoster()
        
        messages = []
        
        #select new messages
        message_select = "SELECT m.message AS text, u.username AS name FROM messages m JOIN users u ON m.user_id = u.user_id"
        cur.execute(message_select)
        select_messages = cur.fetchall()
        for row in select_messages:
            messages.append(dict(row)) 
            
        for message in messages:
            emit('message', message)
        
        emit('isLoggedIn', username)

@socketio.on('search', namespace='/chat')
def on_search(searchtext):

    results = []
    #connect to database
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    username = users[session['uuid']]['username']
    
    print 'connected to db for search'
    
    search_message = "SELECT message FROM messages WHERE message LIKE %s"
    data = ('%'+ searchtext + '%',)
    
    cur.execute(search_message, data)
    search_results = cur.fetchall()
    
    #append to results dict
    for row in search_results:
        results.append(dict(row))
        
    #print to python console
    for search_result in search_results:
        print search_result
        
    #print dict to python console
    print results
    
    print users
    
    #emit the results dict

    if session['isLoggedIn'] == username:
        for result in results:
            print 'something: ', result
            emit('results', result)
    
@socketio.on('disconnect', namespace='/chat')
def on_disconnect():
    print 'disconnect'
    if session['uuid'] in users:
        del users[session['uuid']]
        updateRoster()

@app.route('/', methods=['GET', 'POST'])
def index():
    #connect to database
    
    return app.send_static_file('index.html')
    
@app.route('/chat', methods=['GET', 'POST'])
def chat():
    #connect to database
        
    return app.send_static_file('chat.html')


@app.route('/recipe', methods=['GET', 'POST'])
def recipe():
    #connect to database
        
    return app.send_static_file('recipe.html')
    
@app.route('/js/<path:path>')
def static_proxy_js(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('js', path))
    
@app.route('/css/<path:path>')
def static_proxy_css(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('css', path))
    
@app.route('/img/<path:path>')
def static_proxy_img(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('img', path))
    
if __name__ == '__main__':
    print "A"

    socketio.run(app, host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 8080)), debug=True)
     