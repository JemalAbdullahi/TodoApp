from flask import Flask
from marshmallow import Schema, fields, pre_load, validate
from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy

ma = Marshmallow()
db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer(), primary_key=True)
    username = db.Column(db.String(), unique=True)
    password = db.Column(db.String())
    emailaddress = db.Column(db.String())
    api_key = db.Column(db.String())

    def __init__(self, api_key, emailaddress, password, username):
        self.api_key = api_key
        self.emailaddress = emailaddress
        self.password = password
        self.username = username

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'api_key': self.api_key,
            'id': self.id,
            'username': self.username,
            'password': self.password,
            'emailaddress': self.emailaddress,
        }


class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column(db.Integer(), db.ForeignKey('users.id'))
    title = db.Column(db.String())
    note = db.Column(db.String())
    completed = db.Column(db.Boolean(), default=True, nullable=True)
    repeats = db.Column(db.String())
    # deadline = db.Column(db.String())
    reminders = db.Column(db.String())
    group = db.Column(db.String())
    task_key = db.Column(db.String())

    def __init__(self, title, user_id, note, completed, repeats, group,
                 reminders, task_key):
        self.title = title
        self.user_id = user_id
        #self.deadline = deadline
        self.reminders = reminders
        self.completed = completed
        self.note = note
        self.group = group
        self.repeats = repeats
        self.task_key = task_key

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'title': self.title,
            'user_id': self.user_id,
            'id': self.id,
            'group': self.group,
            'repeats': self.repeats,
            # 'deadline': self.deadline,
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

    def __init__(self, title, task_id, note, completed, repeats, group,
                 reminders):
        self.title = title
        self.task_id = task_id
        #self.deadline = deadline
        self.reminders = reminders
        self.completed = completed
        self.note = note
        self.group = group
        self.repeats = repeats

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
        }