#from operator import truediv
#from flask import Flask
#from marshmallow import Schema, fields, pre_load, validate
#from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy
#from app import db
#ma = Marshmallow()
db = SQLAlchemy()

group_member_table = db.Table(
    'group_member', db.Model.metadata,
    db.Column('group_id', db.Integer(),
              db.ForeignKey('groups.id', ondelete="CASCADE")),
    db.Column('user_id', db.Integer(),
              db.ForeignKey('users.id', ondelete="CASCADE")))


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
    groups = db.relationship("Group",
                             secondary=group_member_table,
                             backref="members")

    def __init__(self, api_key, emailaddress, password, username, firstname,
                 lastname, phonenumber, avatar):
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

    def serialize_public(self):
        return {
            'firstname': self.firstname,
            'lastname': self.lastname,
            'username': self.username,
            'emailaddress': self.emailaddress,
            'phonenumber': self.phonenumber,
            'avatar': self.avatar,
        }

    def get_groups(self):
        groups = []
        for group in self.groups:
            groups.append(Group.serialize(group))
        return groups

    def has_groups(self):
        if len(self.get_groups()) > 0:
            return True
        return False


class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column(db.Integer(),
                        db.ForeignKey('users.id', ondelete="CASCADE"))
    index = db.Column(db.Integer())
    title = db.Column(db.String())
    note = db.Column(db.String(), default="")
    completed = db.Column(db.Boolean(), default=False, nullable=False)
    repeats = db.Column(db.String(), default="")
    reminders = db.Column(db.String(), default="")
    group_id = db.Column(db.Integer(),
                         db.ForeignKey('groups.id', ondelete="CASCADE"))
    task_key = db.Column(db.String(), unique=True)

    def __init__(self, title, user_id, group_id, task_key, index, completed):
        self.title = title
        self.user_id = user_id
        self.group_id = group_id
        self.task_key = task_key
        self.completed = completed
        self.index = index

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'user_id': self.user_id,
            'index': self.index,
            'group_key': self.get_group_key(),
            'group_name': self.get_group_name(),
            'repeats': self.repeats,
            'reminders': self.reminders,
            'completed': self.completed,
            'note': self.note,
            'task_key': self.task_key
        }

    def get_group_key(self):
        return Group.query.filter_by(id=self.group_id).first().group_key

    def get_group_name(self):
        return Group.query.filter_by(id=self.group_id).first().name


class SubTask(db.Model):
    __tablename__ = 'subtasks'

    id = db.Column(db.Integer(), primary_key=True)
    task_id = db.Column(db.Integer(),
                        db.ForeignKey('tasks.id', ondelete="CASCADE"))
    title = db.Column(db.String())
    note = db.Column(db.String())
    completed = db.Column(db.Boolean(), default=False, nullable=False)
    repeats = db.Column(db.String())
    # deadline = db.Column(db.String())
    reminders = db.Column(db.String())
    group = db.Column(db.String())
    index = db.Column(db.Integer())
    subtask_key = db.Column(db.String(), unique=True)

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


class Group(db.Model):
    __tablename__ = 'groups'

    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String())
    group_key = db.Column(db.String(), unique=True)
    is_public = db.Column(db.Boolean(), default=False)

    def __init__(self, name, group_key, is_public):
        self.name = name
        self.group_key = group_key
        self.is_public = is_public

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'members': self.get_members(),
            'group_key': self.group_key,
            'is_public': self.is_public,
        }

    def get_members(self):
        members = []
        for member in self.members:
            members.append(User.serialize_public(member))
        return members

    def is_empty(self):
        if len(self.get_members()) == 0:
            return True
        return False
