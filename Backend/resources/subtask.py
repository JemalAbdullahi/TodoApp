from flask_restful import Resource
from flask import request
from Models import db, SubTask, Task, User
import random
import string
from datetime import datetime


class SubTasks(Resource):
    # Create Subtask
    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"status": "No task key!"}, 400
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                subtask_key = self.generate_key()
                subtask = SubTask.query.filter_by(
                    subtask_key=subtask_key).first()
                while subtask:
                    subtask_key = self.generate_key()
                    subtask = SubTask.query.filter_by(
                        subtask_key=subtask_key).first()
                subtask = SubTask(
                    title=json_data['title'],
                    task_id=task.id,
                    subtask_key=subtask_key,
                )
                db.session.add(subtask)
                db.session.commit()

                result = SubTask.serialize(subtask)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"status": "No task found with that key"}, 404

    # List Subtasks
    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"status": "No Task Key!"}, 401
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                subtasks = SubTask.query.filter_by(task_id=task.id).all()
                for subtask in subtasks:
                    result.append(SubTask.serialize(subtask))
                return {"status": 'success', 'data': result}, 200
            else:
                return {"status": "No task found with that task key"}, 404

        return "<h1>Subtasks!!</h1>"

    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)
        if not header:
            return {"status": "No subtask key!"}, 401
        else:
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                if (subtask.note != json_data['note']):
                    subtask.note = json_data['note']
                if (subtask.completed != json_data['completed']):
                    subtask.completed = json_data['completed']
                if (subtask.due_date != datetime.fromisoformat(json_data['due_date'])):
                    subtask.due_date = datetime.fromisoformat(
                        json_data['due_date'])
                db.session.commit()
                result = SubTask.serialize(subtask)
                return {"status": 'success', 'data': result}, 200
            else:
                return {
                    "status": "No SubTask Found with that subtask key"
                }, 404

    # Delete Subtask
    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"status": "No subtask key!"}, 401
        else:
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                result = SubTask.serialize(subtask)
                db.session.delete(subtask)
                db.session.commit()
                return {"status": 'success', 'data': result}, 200
            else:
                return {
                    "status": 'No Subtask found with that subtask key'
                }, 404

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))
