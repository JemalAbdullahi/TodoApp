from flask_restful import Resource
from flask import request
from models import db, SubTask, Task, User
import random
import string


class SubTasks(Resource):
    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No task key!"}, 400
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                subtask = SubTask(
                    title=json_data['title'],
                    task_id=task.id,
                    note=json_data['note'],
                    completed=json_data['completed'],
                    repeats=json_data['repeats'],
                    group=json_data['group'],
                    reminders=json_data['reminders'],
                )
                db.session.add(subtask)
                db.session.commit()

                result = SubTask.serialize(subtask)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No task with that id"}, 402

    def get(self):
        result = []
        # json_data = request.get_json(force=True)
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No Task Key!"}, 400
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                subtasks = SubTask.query.filter_by(task_id=task.id).all()
                for subtask in subtasks:
                    result.append(SubTask.serialize(subtask))

            return {"status": 'success', 'data': result}, 201