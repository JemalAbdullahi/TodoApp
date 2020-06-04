from flask_restful import Resource
from flask import request
from models import db, User, Task
import random
import string
from models import SubTask


class Tasks(Resource):
    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No api key!"}, 400
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                task_key = self.generate_key()
                task = Task.query.filter_by(task_key=task_key).first()
                while task:
                    task_key = self.generate_key()
                    task = Task.query.filter_by(task_key=task_key).first()

                task = Task(
                    title=json_data['title'],
                    user_id=user.id,
                    note=json_data['note'],
                    completed=json_data['completed'],
                    repeats=json_data['repeats'],
                    group=json_data['group'],
                    reminders=json_data['reminders'],
                    task_key=task_key,
                    index = json_data['index'],
                )
                db.session.add(task)
                db.session.commit()

                result = Task.serialize(task)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No user with that api key"}, 402

    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No api key!"}, 400
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                tasks = Task.query.filter_by(user_id=user.id).all()
                for task in tasks:
                    result.append(Task.serialize(task))

            return {"status": 'success', 'data': result}, 201

    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No task key!"}, 400
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                if (task.title != json_data['title']):
                    task.title = json_data['title']
                if (task.note != json_data['note']):
                    task.note = json_data['note']
                if (task.completed != json_data['completed']):
                    task.completed = json_data['completed']
                if (task.repeats != json_data['repeats']):
                    task.repeats = json_data['repeats'],
                if (task.group != json_data['group']):
                    task.group = json_data['group']
                if (task.reminders != json_data['reminders']):
                    task.reminders = json_data['reminders']
                if (task.index != json_data['index']):
                    task.index = json_data['index']

                db.session.commit()

                result = Task.serialize(task)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No Task with that task key"}, 402

    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No task key!"}, 400
        else:
            task = Task.query.filter_by(task_key=header).first()
            result = Task.serialize(task)
            subtasks = SubTask.query.filter_by(task_id=task.id).all()
            for subtask in subtasks:
                db.session.delete(subtask)
            db.session.commit()
            db.session.delete(task)
            db.session.commit()
            return {"status": 'success', 'data': result}, 201

    
    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))