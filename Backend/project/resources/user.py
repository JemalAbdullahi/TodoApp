from flask_restful import Resource
from flask import request
from models import db, User
import random
import string


class Users(Resource):
    def get(self):
        users = User.query.all()
        user_list = []
        for i in range(0, len(users)):
            user_list.append(users[i].serialize())
        return {"status": str(user_list)}, 200

    def post(self):
        json_data = request.get_json(force=True)

        if not json_data:
            return {'message': 'No input data provided'}, 400

        user = User.query.filter_by(username=json_data['username']).first()
        if user:
            return {'message': 'Username not available'}, 400

        user = User.query.filter_by(
            emailaddress=json_data['emailaddress']).first()
        if user:
            return {'message': 'Email address already exists'}, 400

        api_key = self.generate_key()

        user = User.query.filter_by(api_key=api_key).first()
        if user:
            return {'message': 'API key already exists'}, 400

        user = User(
            api_key=api_key,
            #firstname=json_data['firstname'],
            #lastname=json_data['lastname'],
            emailaddress=json_data['emailaddress'],
            password=json_data['password'],
            username=json_data['username'],
        )
        db.session.add(user)
        db.session.commit()

        result = User.serialize(user)

        return {"status": 'success', 'data': result}, 201

    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)
        if not header:
            return {'Messege': "No API key!"}, 400
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                if user.password != json_data["oldPassword"]:
                    oldPassword = json_data["oldPassword"]
                    return {"Message": "Incorrect Current Password"}
                else:
                    if (user.emailaddress != json_data['email']):
                        user.emailaddress = json_data['email']
                    if (user.password != json_data['newPassword']):
                        user.password = json_data['newPassword']

                db.session.commit()

                result = User.serialize(user)
                return {"status": 'success', 'data': result}, 201

            else:
                return {'Messege': "No User with that api key"}, 402

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))