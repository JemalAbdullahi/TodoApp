from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
import datetime

db = SQLAlchemy()

group_member_table = db.Table(
    'group_member', db.Model.metadata,
    db.Column('group_id', db.Integer(),
              db.ForeignKey('groups.id', ondelete="CASCADE"), primary_key=True),
    db.Column('user_id', db.Integer(),
              db.ForeignKey('users.id', ondelete="CASCADE"), primary_key=True)
)

user_assigned_to_subtask_table = db.Table(
    'user_assigned_to_subtask',
    db.Model.metadata,
    db.Column('user_id', db.Integer(),
              db.ForeignKey('users.id', ondelete='CASCADE'),
              primary_key=True
              ),
    db.Column('subtask_id', db.Integer(),
              db.ForeignKey('subtasks.id', ondelete='CASCADE'),
              primary_key=True
              ),
)


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer(), primary_key=True)
    firstname = db.Column(db.String(), nullable=False)
    lastname = db.Column(db.String(), nullable=False)
    phonenumber = db.Column(db.String(15), unique=True, nullable=False)
    username = db.Column(db.String(64), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    emailaddress = db.Column(db.String(120), nullable=False)
    api_key = db.Column(db.String(), unique=True)
    avatar = db.Column(db.LargeBinary)
    time_created = db.Column(db.DateTime(
        timezone=False), server_default=db.func.now())
    time_updated = db.Column(db.DateTime(
        timezone=False), onupdate=db.func.now())
    groups = db.relationship("Group",
                             secondary=group_member_table,
                             backref="members")

    def __init__(self, api_key, emailaddress, password, username, firstname,
                 lastname, phonenumber):
        self.api_key = api_key
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.password = generate_password_hash(password)
        self.emailaddress = emailaddress
        self.phonenumber = phonenumber

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def verify_password(self, pwd):
        return check_password_hash(self.password, pwd)

    def serialize(self):
        if self.time_updated is None:
            time_updated = self.time_created.isoformat()
        else:
            time_updated = self.time_updated.isoformat()
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
            'time_created': self.time_created.isoformat(),
            'time_updated': time_updated
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
    title = db.Column(db.String(), nullable=False)
    note = db.Column(db.String(), default="")
    completed = db.Column(db.Boolean(), default=False)

    repeats = db.Column(db.String(), default="")
    reminders = db.Column(db.String(), default="")
    time_created = db.Column(db.DateTime(
        timezone=False), server_default=db.func.now())
    time_updated = db.Column(db.DateTime(
        timezone=False), onupdate=db.func.now())
    group_id = db.Column(db.Integer(),
                         db.ForeignKey('groups.id', ondelete="CASCADE"))
    task_key = db.Column(db.String(), unique=True)

    def __init__(self, title, user_id, group_id, task_key):
        self.title = title
        self.user_id = user_id
        self.group_id = group_id
        self.task_key = task_key

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        if self.time_updated is None:
            time_updated = self.time_created.isoformat()
        else:
            time_updated = self.time_updated.isoformat()
        return {
            'id': self.id,
            'title': self.title,
            'user_id': self.user_id,
            'group_key': self.get_group_key(),
            'group_name': self.get_group_name(),
            'repeats': self.repeats,
            'reminders': self.reminders,
            'completed': self.completed,
            'note': self.note,
            'task_key': self.task_key,
            'time_created': self.time_created.isoformat(),
            'time_updated': time_updated
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
    subtask_key = db.Column(db.String(), unique=True)
    title = db.Column(db.String(), nullable=False)
    completed = db.Column(db.Boolean(), default=False)
    note = db.Column(db.String(), default="")
    repeats = db.Column(db.String())
    due_date = db.Column(db.DateTime(timezone=False))
    reminders = db.Column(db.String())
    time_created = db.Column(db.DateTime(
        timezone=False), server_default=db.func.now())
    time_updated = db.Column(db.DateTime(
        timezone=False), onupdate=db.func.now())

    assigned_to_user = db.relationship("User",
                                       secondary=user_assigned_to_subtask_table,
                                       backref="subtask")

    def __init__(self, title, task_id, subtask_key):
        self.title = title
        self.task_id = task_id
        self.subtask_key = subtask_key

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        if self.time_updated is None:
            time_updated = self.time_created.isoformat()
        else:
            time_updated = self.time_updated.isoformat()
        return {
            'id': self.id,
            'task_id': self.task_id,
            'subtask_key': self.subtask_key,
            'title': self.title,
            'completed': self.completed,
            'note': self.note,
            'repeats': self.repeats,
            'due_date': datetime.date.today().isoformat() if self.due_date is None else self.due_date.isoformat(),
            'reminders': self.reminders,
            'time_created': self.time_created.isoformat(),
            'time_updated': time_updated,
            'assigned_to': self.get_users_assigned_to()
        }

    def get_users_assigned_to(self):
        assigned_to = []
        for user in self.assigned_to_user:
            assigned_to.append(User.serialize_public(user))
        return assigned_to


class Group(db.Model):
    __tablename__ = 'groups'

    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String())
    group_key = db.Column(db.String(), unique=True)
    is_public = db.Column(db.Boolean(), default=False)
    time_created = db.Column(db.DateTime(
        timezone=False), server_default=db.func.now())
    time_updated = db.Column(db.DateTime(
        timezone=False), onupdate=db.func.now())

    def __init__(self, name, group_key, is_public):
        self.name = name
        self.group_key = group_key
        self.is_public = is_public

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        if self.time_updated is None:
            time_updated = self.time_created.isoformat()
        else:
            time_updated = self.time_updated.isoformat()
        return {
            'id': self.id,
            'name': self.name,
            'members': self.get_members(),
            'group_key': self.group_key,
            'is_public': self.is_public,
            'time_created': self.time_created.isoformat(),
            'time_updated': time_updated
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
