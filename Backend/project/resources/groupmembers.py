from flask_restful import Resource
from flask import request
from Models import db, User, Group

class GroupMembers(Resource):

    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No group key!"}, 400
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                members = group.members
                for member in members:
                    result.append(User.serialize(member))

            return {"status": 'success', 'data': result}, 201


    def post(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not json_data:
            return {'Message': 'No input data provided'}, 400
        if not header:
            return {"Messege": "No group key!"}, 400
        else:
            group = Group.query.filter_by(group_key=header).first()
            if group:
                member = User.query.filter_by(username = json_data['username']).first()
                group.members.append(member)
                db.session.commit()

                result = Group.serialize(group)
                return {"status": 'success', 'data': result}, 201
            else:
                return {"Messege": "No user with that api key"}, 402

    
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

    """ Delete Members to be created at a later date
    def delete(self):
        header = request.headers["Authorization"]

        if not header:
            return {"Messege": "No group key!"}, 400
        else:
            group = Group.query.filter_by(group_key=header).first()
            result = Group.serialize(group)
            db.session.delete(group)
            db.session.commit()
            return {"status": 'success', 'data': result}, 201
    """
