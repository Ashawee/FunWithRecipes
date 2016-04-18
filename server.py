import sys
reload(sys)
sys.setdefaultencoding("UTF8")
import os
import uuid
from flask import Flask, session, request, redirect, url_for, render_template
from flask.ext.socketio import SocketIO, emit
import psycopg2
import psycopg2.extras
from datetime import datetime

app = Flask(__name__, static_url_path='')
app.secret_key = os.urandom(24).encode('hex')

socketio = SocketIO(app)
users = []
global results
results=[]
def connectToDB():
  #connectionString = 'dbname=socketio user=ircclient password=X7pjgd27 host=localhost'
  connectionString = 'dbname=funwithrecipes user=recipes_admin password=recip3Mast3r host=localhost'
  print connectionString
  try:
    return psycopg2.connect(connectionString);
  except:
    print("Can't connect to database")


def updateRoster():
    names = []
    for user_id in users:
        print users[user_id]['username']
        names.append(users[user_id]['username'])
    print users
    print 'broadcasting names'
    emit('roster', names, broadcast=True)
    
@socketio.on('connect', namespace='/recipe')
def test_connect():
    session['uuid'] = uuid.uuid1()
    print 'connected'
    

@socketio.on('load', namespace='/recipe')
def load(name):
    #connect to database
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    #select recipes for front page
    recipe_select = "SELECT r.recipe AS name, r.created, r.difficulty, r.image, c.category FROM recipes r JOIN recipe_categories rc ON r.recipe_id = rc.recipe_id JOIN categories c on c.category_id = rc.category_id ORDER BY r.created LIMIT 5; "
    cur.execute(recipe_select,)
    recipe_results = cur.fetchall();
    
    recipes = []
    for row in recipe_results:
        recipes.append(dict(row))
    
    for recipe in recipes:
        detail = {'name': recipe['name'], 'difficulty': recipe['difficulty'], 'image': recipe['image'], 'category': recipe['category']}
        print detail
        emit('recipes', detail)

    #select categories for front page
    category_select = "SELECT category from categories; "
    cur.execute(category_select,)
    category_results = cur.fetchall();
    
    categories = []
    for row in category_results:
        categories.append(dict(row))
    
    for category in categories:
        mem = {'name': category['category'], }
        print mem
        emit('categories', mem)
        
        
@socketio.on('identify', namespace='/recipe')
def on_identify(name):
    print ('identify' + name)
#    users[session['uuid']] = {'username': name}
    

@socketio.on('check', namespace='/recipe')
def checking(pw):
    
    username = users[session['uuid']]['username']

@socketio.on('search', namespace='/recipe')
def on_search(searchtext):

    results = []
    #connect to database
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    username = users[session['uuid']]['username']
    
    print 'connected to db for searching recipes'
    search_recipes = ""
    data = ('%'+ searchtext + '%',)
    cur.execute(search_recipes, data)
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
    global results
    #return render_template('index.html',username=results)
    return app.send_static_file('index.html')
    
@app.route('/chat', methods=['GET', 'POST'])
def chat():
    #connect to database
        
    return app.send_static_file('chat.html')


@app.route('/recipe', methods=['GET', 'POST'])
def recipe():
    #connect to database
        
    return app.send_static_file('recipe.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    #connect to database
      #connect to database
    
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    print(request.method)
    if request.method == 'POST':
        
        data = (request.form['username'],request.form['pw'],)
        print(data)
        cur.execute("select username from users where username = (%s) AND password = crypt(%s,password)", data)
        global results
        results = cur.fetchone()
        if cur.rowcount>0:
    		print("yes")
    		session['userName'] = request.form['name']
        else:
    		print("no")
<<<<<<< HEAD
    		
    if 'userName' in session:
        user = [session['userName']]
    else:
        user = ['']	
        
    return app.send_static_file('login.html')
=======
    	
    return render_template('login.html',username=results)
    #return app.send_static_file('login.html')
>>>>>>> dbf88c275ad4e7421db7b232cfd6158f8cbfeb97
    
@app.route('/register', methods=['GET', 'POST'])
def register():
    conn=connectToDB()
    cur=conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    print(request.method)
    if request.method =='POST': 
        data = (request.form['username'],request.form['password'],)
        try:
            cur.execute("insert into users (username,password) values(%s,crypt(%s,gen_salt('bf')))" ,data)
        except:
            print("ERROR inserting user")
            conn.rollback()
        conn.commit()
    
    #connect to database
    		
    	
        
    return app.send_static_file('register.html')

@app.route('/submit-recipe', methods=['GET', 'POST'])
def submit_recipe():
    #connect to database
        
    return app.send_static_file('submit_recipe.html')
    
@app.route('/recipe-list', methods=['GET', 'POST'])
def recipe_list():
    #connect to database
        
    return app.send_static_file('recipe_list.html')

@app.route('/search-result', methods=['GET', 'POST'])
def search_result():
    #connect to database
        
    return app.send_static_file('search_result.html')
    
@app.route('/static/js/<path:path>')
def static_proxy_js(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('js', path))
    
@app.route('/static/css/<path:path>')
def static_proxy_css(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('css', path))
    
@app.route('/static/img/<path:path>')
def static_proxy_img(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('img', path))
    
if __name__ == '__main__':
    print "A"

    socketio.run(app, host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 8080)), debug=True)
     