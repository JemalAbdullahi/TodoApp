from flask_restful import Resource
from flask import request
from Models import User
import random
import string


class Signin(Resource):
    def post(self):
        result = ""
        json_data = request.get_json(force=True)
        header = request.headers["Authorization"]

        if not header:
            result = self.username_and_password_signin(json_data)

        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                result = User.serialize(user)
                return {"status": 'success', 'data': result}, 200
            else:
                result = self.username_and_password_signin(json_data)

        return result

    def username_and_password_signin(self, json_data):
        if not json_data:
            return {'Message': 'No input data provided'}, 400

        user = User.query.filter_by(username=json_data['username']).first()
        if not user:
            return {'Message': 'Username does not exist'}, 404

        if user.password != json_data['password']:
            return {'Message': 'Password incorrect'}, 401

        result = User.serialize(user)
        return {"status": 'success', 'data': result}, 200

    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))
