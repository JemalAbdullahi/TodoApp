from flask import Blueprint
from flask_restful import Api
from resources.user import Users
from resources.Signin import Signin
from resources.task import Tasks
from resources.subtask import SubTasks

api_bp = Blueprint('api', __name__)
api = Api(api_bp)

# Route
api.add_resource(Users, '/user')

api.add_resource(Signin, '/signin')

api.add_resource(Tasks, '/tasks')

api.add_resource(SubTasks, '/subtasks')