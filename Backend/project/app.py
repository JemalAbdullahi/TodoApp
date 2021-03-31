from flask import Blueprint
import flask
from flask_restful import Api
from resources.group import Groups
from resources.groupmembers import GroupMembers
from resources.user import Users
from resources.Signin import Signin
from resources.task import Tasks
from resources.subtask import SubTasks
from resources.search import Search

api_bp = Blueprint('api', __name__)
api = Api(api_bp)

def create_app(config_filename):
    app = flask(__name__)
    app.config.from_object(config_filename)

    app.register_blueprint(api_bp, url_prefix='/api')

    from Models import db
    db.init_app(app)

    return app

# app

app = create_app("config")

# Route
api.add_resource(Users, '/user')

api.add_resource(Groups, '/group')

api.add_resource(GroupMembers, '/groupmember')

api.add_resource(Signin, '/signin')

api.add_resource(Tasks, '/tasks')

api.add_resource(SubTasks, '/subtasks')

api.add_resource(Search, '/search')