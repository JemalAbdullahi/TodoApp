from flask_restful import Resource
from flask import request
from models import db, User, Task
import random
import string


class Tasks(Resource):

    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)


        if not header:
            return {"Messege" : "No api key!"}, 400
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                task_key = self.generate_key()
                task = Task.query.filter_by(task_key=task_key).first()
                while task:
                    task_key = self.generate_key()
                    task = Task.query.filter_by(task_key=task_key).first()
                    
                task = Task(
                    title = json_data['title'],
                    user_id = user.id,
                    note = json_data['note'],
                    completed = json_data['completed'],
                    repeats = json_data['repeats'],
                    group = json_data['group'],
                    reminders = json_data['reminders'],
                    task_key = task_key,
                )
                db.session.add(task)
                db.session.commit()

                result = Task.serialize(task)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege" : "No user with that api key"}, 402

    def get(self):
        result = []
        # json_data = request.get_json(force=True)
        header = request.headers["Authorization"]

        if not header:
            return {"Messege" : "No api key!"}, 400
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                tasks = Task.query.filter_by(user_id=user.id).all()
                for task in tasks:
                    result.append(Task.serialize(task))


            return {"status": 'success', 'data': result}, 201

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))