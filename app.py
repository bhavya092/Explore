import os
import secrets
import json
from PIL import Image
import random
from flask import render_template, url_for, flash, redirect,request,abort
from flask import Flask,jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from datetime import datetime
from flask_login import  UserMixin
from flask_login import login_user,current_user,logout_user,login_required

#========================================================================
app = Flask(__name__)
app.config['SECRET_KEY'] = '5791628bb0b13ce0c676dfde280ba245'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'
db = SQLAlchemy(app)
bcrypt=Bcrypt(app)
login_manager=LoginManager(app)
login_manager.login_view='login'
login_manager.login_message_category='info'

#===========================================================================
profile=["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaGY77SNf8NI2VdW7r__Wyzfow4r2kAnED0Q&usqp=CAU",
         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZvQO2S4-7nW474WmRUxce6OT0IrtpG23dfg&usqp=CAU",
         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe3a6ooJ1jXNuijHg_eFAqwisTAjYvMvKvP45S6782EYH0qNZ3DAQJE5LFCj3r0HEkXCgyTp2JVmg2Li-KoG7Akhst8UFzw1X-RQ&usqp=CAU&ec=45761792",
         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPtCZRNMC91f1_uji5XSKG43sMCUk_u7yzFgG3S5yxv9DnZ8Xq8WEiEOKtpiFJFrbjxFQ1thtUId_P_5fxIiJhK7BXXetV56eadQ&usqp=CAU&ec=45761792",
         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxM304Po8LqZtKDkUTXOAsiCpvXQTAAsB4jA&usqp=CAU"]

#===========================================================================

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model,UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    dp = db.Column(db.String(200), nullable=False,)
    password = db.Column(db.String(60), nullable=False)

    def __repr__(self):
        return f"User('{self.username}', '{self.email}')"


class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    author = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(100), nullable=False)
    image = db.Column(db.String(100), nullable=False)
    date_posted = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    content = db.Column(db.Text, nullable=False)
    author_id = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return f"Post('{self.location}', '{self.author}')"


#============================================================================

@app.route('/',methods=["GET"])
def home_page():
    final=[]
    posts = Post.query.order_by(Post.date_posted.desc())
    for post in posts:
        dic={'id':post.id,
            'author':post.author,
            'location':post.location,
            'image' :post.image,
            'date_posted':post.date_posted,
            'content':post.content,
            'author_id':post.author_id}
        final.append(dic)
    return jsonify({'posts':final})

@app.route('/post',methods=['GET','POST'])
def post():
    if request.method=='POST':
        request_data=request.data 
        request_data=json.loads(request_data.decode('utf-8'))
        location=request_data['location']
        author=request_data['author']
        content=request_data['content']
        image=request_data['image']
        author_id=request_data['author_id']
        newPost=Post(location=location,content=content,author=author,image=image,author_id=author_id)
        db.session.add(newPost)
        db.session.commit()
    else:
        print("hello")
    return ""

@app.route('/signup',methods=['GET','POST'])
def signup():
    if request.method=='POST':
        request_data=request.data 
        request_data=json.loads(request_data.decode('utf-8'))
        username=request_data['username']
        email=request_data['email']
        password=request_data['password']
        x=random.choice([0,1,2,3,4])
        dp=profile[x]
        newUser=User(username=username,email=email,password=password,dp=dp)
        db.session.add(newUser)
        db.session.commit()
    else:
        print("hello")
    return ""

@app.route("/signin", methods=['GET', 'POST'])
def signin():
    if request.method=='POST' or request.method=='GET':
        request_data=request.data 
        request_data=json.loads(request_data.decode('utf-8'))
        email=request_data['email']
        password=request_data['password']
        user=User.query.filter_by(email=email,password=password).first()
        if user:
            login_user(user,remember=True)
            return jsonify({'isUser':'1'})
        else:
            return jsonify({'isUser':'0'})
        
        
'''@app.route('/profile',methods=["GET"])
def profile():
    final=[]
    posts = Post.query.filter_by(author=current_user['username']).order_by(Post.date_posted.desc())
    for post in posts:
        dic={'id':post.id,
            'author':post.author,
            'location':post.location,
            'image' :post.image,
            'date_posted':post.date_posted,
            'content':post.content,
            'author_id':post.author_id}
        final.append(dic)
    return jsonify({'posts':final})'''
    
    

        

if __name__ == '__main__':
    app.run(debug=True)