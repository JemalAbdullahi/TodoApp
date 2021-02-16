from flask_restful import Resource
from flask import request
from Models import db, User, Group
import random
import string


class Groups(Resource):
    #Create a Group
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
                group_key = self.generate_key()
                group = Group.query.filter_by(group_key=group_key).first()
                while group:
                    group_key = self.generate_key()
                    group = Group.query.filter_by(group_key=group_key).first()

                group = Group(name=json_data['name'], group_key=group_key)
                user.groups.append(
                    group
                )  # can alter to group.members.append(user,user,user) depending on UI implementaion
                db.session.add(group)
                db.session.commit()

                result = Group.serialize(group)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No user with that api key"}, 404
    
    #List User's Groups
    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No api key!"}, 401
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                groups = user.groups
                for group in groups:
                    result.append(Group.serialize(group))

            return {"status": 'success', 'data': result}, 200

    #Update Group
    def patch(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {"Messege": "No group key!"}, 401
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                if (group.name != json_data['name']):
                    group.name = json_data['name']
                #add members field

                db.session.commit()

                result = Group.serialize(group)
                return {"status": 'success', 'data': result}, 200
            else:
                return {"Messege": "No Group with that group key"}, 404

    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No group key!"}, 401
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                result = Group.serialize(group)
                db.session.delete(group)
                db.session.commit()
                return {"status": 'success', 'data': result}, 200
            else:
                return {"status": 'Group Not Found'}, 404

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))