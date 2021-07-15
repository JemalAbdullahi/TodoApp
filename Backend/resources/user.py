from flask_restful import Resource
from flask import request
from Models import db, User
import random
import string


class Users(Resource):
    """ # Get User List
    def get(self):
        users = User.query.all()
        user_list = []
        for user in users:
            user_list.append(user.serialize())
        return {"status": user_list}, 200 """

    # Create New User (Sign Up/register User)
    def post(self):
        json_data = request.get_json(force=True)

        if not json_data:
            return {'status': 'No input data provided'}, 400

        user = User.query.filter_by(username=json_data['username']).first()
        if user:
            return {'status': 'Username is already taken'}, 409

        user = User.query.filter_by(
            emailaddress=json_data['emailaddress']).first()
        if user:
            return {'status': 'Email address already exists'}, 409

        user = User.query.filter_by(
            phonenumber=json_data['phonenumber']).first()
        if user:
            return {'status': 'Phone Number already exists'}, 409

        api_key = self.generate_key()
        user = User.query.filter_by(api_key=api_key).first()
        while user:
            api_key = self.generate_key()
            user = User.query.filter_by(api_key=api_key).first()

        user = User(
            api_key=api_key,
            firstname=json_data['firstname'],
            lastname=json_data['lastname'],
            username=json_data['username'],
            password=json_data['password'],
            emailaddress=json_data['emailaddress'],
            phonenumber=json_data['phonenumber'],
        )
        db.session.add(user)
        db.session.commit()

        result = User.serialize(user)

        return {"status": 'success', 'data': result}, 201

    # Update User Profile
    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)
        if not header:
            return {'status': "No API key!"}, 401
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                if user.verify_password(json_data["currentPassword"]):
                    return {"status": "Incorrect Current Password"}
                else:
                    if (user.username != json_data['username']):
                        user.username = json_data['username']
                    if (user.firstname != json_data['firstname']):
                        user.firstname = json_data['firstname']
                    if (user.lastname != json_data['lastname']):
                        user.lastname = json_data['lastname']
                    if (user.phonenumber != json_data['phonenumber']):
                        user.phonenumber = json_data['phonenumber']
                    if (user.avatar != json_data['avatar']):
                        user.avatar = json_data['avatar']
                    if (user.emailaddress != json_data['email']):
                        user.emailaddress = json_data['email']
                    if (user.password != json_data['newPassword']):
                        user.password = json_data['newPassword']

                db.session.commit()

                result = User.serialize(user)
                return {"status": 'success', 'data': result}, 200

            else:
                return {'status': "No User found with that api key"}, 404

    # Generate new api key
    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))
