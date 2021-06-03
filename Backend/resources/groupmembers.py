from flask_restful import Resource
from flask import request
from Models import db, Task, User, Group



class GroupMembers(Resource):

    # List Members of a Group
    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No group key!"}, 401
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                result = group.get_members()
                return {"status": 'success', 'data': result}, 200
            else:
                return {"status": "Group Not Found"}, 404

    # Add Members to a Group, only if Group is public
    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not json_data:
            return {'Message': 'No input data provided'}, 400
        if not header:
            return {"Messege": "No group key!"}, 401
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                if group.is_public:
                    member = User.query.filter_by(
                        username=json_data['username']).first()
                    if member:
                        for m in group.members:
                            if member.username == m.username:
                                return {"status": "User is already added"}, 409
                        group.members.append(member)
                        db.session.commit()
                        result = group.get_members()
                        return {"status": 'success', 'data': member}, 201
                    else:
                        return {
                            "status": 'No user found by that username'
                        }, 404
                else:
                    return {"status": 'Group is not public'}, 403
            else:
                return {"Messege": "No Group Found with that group key"}, 404

    """ Update Group Members: to be create if roles are implemented
    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No group key!"}, 400
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                if (group.name != json_data['name']):
                    group.name = json_data['name']
                #add members field

                db.session.commit()

                result = Group.serialize(group)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No Group with that group key"}, 402 
    """

    # Delete Members: Also, delete Member's tasks related to the specified Group
    def delete(self):
        header = request.headers["Authorization"]
        username = request.args.get('username')

        if not header:
            return {"Messege": "No group key!"}, 401
        if not username:
            return {'Message': 'No username provided'}, 400
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:

                for m in group.members:
                    if m.username == username:
                        result = User.serialize(m)
                        group_tasks = Task.query.filter_by(group_id=group.id)
                        for task in group_tasks:
                            db.session.delete(task)
                        group.members.remove(m)
                        if group.is_empty():
                            db.session.delete(group)
                        db.session.commit()
                        return {"status": 'success', "data": result}, 200
                return {"status": "Member Not Found in Group"}, 404
            else:
                return {"status": "Group Not Found"}, 404
