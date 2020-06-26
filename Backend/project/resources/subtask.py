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
                    note=json_data['note'],
                    completed=json_data['completed'],
                    repeats=json_data['repeats'],
                    group=json_data['group'],
                    reminders=json_data['reminders'],
                    subtask_key=subtask_key,
                    index=json_data['index'],
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

    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)
        if not header:
            return {"Messege": "No subtask key!"}, 400
        else:
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                if (subtask.title != json_data['title']):
                    subtask.title = json_data['title']
                if (subtask.note != json_data['note']):
                    subtask.note = json_data['note']
                if (subtask.completed != json_data['completed']):
                    subtask.completed = json_data['completed']
                if (subtask.repeats != json_data['repeats']):
                    subtask.repeats = json_data['repeats'],
                if (subtask.group != json_data['group']):
                    subtask.group = json_data['group']
                if (subtask.reminders != json_data['reminders']):
                    subtask.reminders = json_data['reminders']
                if (subtask.index != json_data['index']):
                    subtask.index = json_data['index']
                db.session.commit()
                result = SubTask.serialize(subtask)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No SubTask with that subtask key"}, 402
                
    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No subtask key!"}, 400
        else:
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            result = SubTask.serialize(subtask)
            db.session.delete(subtask)
            db.session.commit()
            return {"status": 'success', 'data': result}, 201

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))