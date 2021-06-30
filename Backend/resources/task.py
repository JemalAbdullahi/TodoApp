from flask_restful import Resource
from flask import request
from Models import db, Group, User, Task, SubTask
import random
import string


class Tasks(Resource):
    # Create Task
    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not json_data:
            return {'Message': 'No input data provided'}, 400
        if not header:
            return {"Messege": "No api key!"}, 401
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                group = Group.query.filter_by(
                    group_key=json_data['group_key']).first()
                if group:
                    task_key = self.generate_key()
                    task = Task.query.filter_by(task_key=task_key).first()
                    while task:
                        task_key = self.generate_key()
                        task = Task.query.filter_by(task_key=task_key).first()

                    task = Task(
                        title=json_data['title'],
                        user_id=user.id,
                        group_id=group.id,
                        task_key=task_key,
                    )
                    db.session.add(task)
                    db.session.commit()

                    result = Task.serialize(task)
                    return {"status": 'success', 'data': result}, 201
                else:
                    return {
                        "Messege": "No Group found with that group key"
                    }, 404
            else:
                return {"Messege": "No user with that api key"}, 404

    # List Task //Change to List GROUP TASK, NO NESTED FOR LOOP
    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No group key!"}, 401
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                tasks = Task.query.filter_by(group_id=group.id).all()
                for task in tasks:
                    result.append(Task.serialize(task))
                return {"status": 'success', 'data': result}, 200
            else:
                return {"Message": "Group Not Found"}, 404

    # Update Task
    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No task key!"}, 401
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                if (task.completed != json_data['completed']):
                    task.completed = json_data['completed']

                db.session.commit()

                result = Task.serialize(task)
                return {"status": 'success', 'data': result}, 200
            else:
                return {"Messege": "No Task with that task key"}, 404

    # Delete Task
    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No task key!"}, 401
        else:
            task = Task.query.filter_by(task_key=header).first()
            if task:
                result = Task.serialize(task)
                subtasks = SubTask.query.filter_by(task_id=task.id).all()
                for subtask in subtasks:
                    db.session.delete(subtask)
                db.session.commit()
                db.session.delete(task)
                db.session.commit()
                return {"status": 'success', 'data': result}, 200
            else:
                return {"Message": 'No Task found with that task key'}, 404

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))
