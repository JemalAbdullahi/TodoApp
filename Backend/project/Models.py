from flask import Flask
from marshmallow import Schema, fields, pre_load, validate
from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy

ma = Marshmallow()
db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer(), primary_key=True)
    firstname = db.Column(db.String())
    lastname = db.Column(db.String())
    phonenumber = db.Column(db.String(15), unique=True)
    username = db.Column(db.String(64), unique=True)
    password = db.Column(db.String(128))
    emailaddress = db.Column(db.String(120))
    api_key = db.Column(db.String())
    avatar = db.Column(db.LargeBinary)

    def __init__(self, api_key, emailaddress, password, username, firstname, lastname, phonenumber, avatar):
        self.api_key = api_key
        self.emailaddress = emailaddress
        self.password = password
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
        self.avatar = avatar

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'api_key': self.api_key,
            'id': self.id,
            'username': self.username,
            'password': self.password,
            'emailaddress': self.emailaddress,
            'firstname': self.firstname,
            'lastname': self.lastname,
            'phonenumber': self.phonenumber,
            'avatar': self.avatar,
        }


class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column(db.Integer(), db.ForeignKey('users.id'))
    index = db.Column(db.Integer())
    title = db.Column(db.String())
    note = db.Column(db.String())
    completed = db.Column(db.Boolean(), default=False, nullable=False)
    repeats = db.Column(db.String())
    reminders = db.Column(db.String())
    group = db.Column(db.String())
    task_key = db.Column(db.String())

    def __init__(self, title, user_id, note, completed, repeats, group,
                 reminders, task_key, index):
        self.title = title
        self.user_id = user_id
        self.reminders = reminders
        self.completed = completed
        self.note = note
        self.group = group
        self.repeats = repeats
        self.task_key = task_key
        self.index = index

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'user_id': self.user_id,
            'index': self.index,
            'group': self.group,
            'repeats': self.repeats,
            'reminders': self.reminders,
            'completed': self.completed,
            'note': self.note,
            'task_key': self.task_key
        }


class SubTask(db.Model):
    __tablename__ = 'subtasks'

    id = db.Column(db.Integer(), primary_key=True)
    task_id = db.Column(db.Integer(), db.ForeignKey('tasks.id'))
    title = db.Column(db.String())
    note = db.Column(db.String())
    completed = db.Column(db.Boolean(), default=False, nullable=False)
    repeats = db.Column(db.String())
    # deadline = db.Column(db.String())
    reminders = db.Column(db.String())
    group = db.Column(db.String())
    index = db.Column(db.Integer())
    subtask_key = db.Column(db.String())

    def __init__(self, title, task_id, note, completed, repeats, group,
                 reminders, index, subtask_key):
        self.title = title
        self.task_id = task_id
        #self.deadline = deadline
        self.reminders = reminders
        self.completed = completed
        self.note = note
        self.group = group
        self.repeats = repeats
        self.index = index
        self.subtask_key = subtask_key

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'title': self.title,
            'task_id': self.task_id,
            'id': self.id,
            'repeats': self.repeats,
            # 'deadline': self.deadline,
            'reminders': self.reminders,
            'completed': self.completed,
            'note': self.note,
            'index': self.index,
            'subtask_key': self.subtask_key
        }