from flask_restful import Resource
from flask import request
from Models import db, SubTask, Task, User


class AssignedToUser(Resource):

    # List Members of a Group
    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No subtask key!"}, 401
        else:
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                result = subtask.get_users_assigned_to()
                return {"status": 'success', 'data': result}, 200
            else:
                return {"status": "Subtask Not Found"}, 404

    # Add Members to a Group, only if Group is public
    def post(self):
        header = request.headers["Authorization"]
        username = request.args.get('username')

        if not header:
            return {"Messege": "No subtask key!"}, 401
        if not username:
            return {'Message': 'No username provided'}, 400
        else:
            # Obtain subtask associated to the unique key
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                user = User.query.filter_by(
                        username=username).first()
                if user:
                    # Check each member the subtask is assigned to, if a match with the provided username, then remove assignment
                    for m in subtask.assigned_to_user:
                        if user.username == m.username:
                            return {"status": "User is already assigned to Task"}, 409
                    subtask.assigned_to_user.append(user)
                    db.session.commit()
                    result = User.serialize_public(user)
                    return {"status": 'success', 'data': result}, 201
                else:
                    return {"status": "No user found by that username"}, 404
            else:
                return {"status": "Subtask Not Found"}, 404

    # Delete User assigned to subtask
    def delete(self):
        header = request.headers["Authorization"]
        username = request.args.get('username')

        if not header:
            return {"Messege": "No subtask key!"}, 401
        if not username:
            return {'Message': 'No username provided'}, 400
        else:
            # Obtain subtask associated to the unique key
            subtask = SubTask.query.filter_by(subtask_key=header).first()
            if subtask:
                # Check each member the subtask is assigned to, if a match with the provided username, then remove assignment
                for m in subtask.assigned_to_user:
                    if m.username == username:
                        result = User.serialize(m)
                        subtask.assigned_to_user.remove(m)
                        db.session.commit()
                        return {"status": 'success', "data": result}, 200
                return {"status": "Subtask not assigned to User"}, 404
            else:
                return {"status": "Subtask Not Found"}, 404
