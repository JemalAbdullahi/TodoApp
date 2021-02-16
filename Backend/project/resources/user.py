from flask_restful import Resource
from flask import request
from Models import db, User
import random
import string


class Users(Resource):
    #Get User List
    def get(self):
        users = User.query.all()
        user_list = []
        for user in users:
            user_list.append(user.serialize())
        return {"status": user_list}, 200

    #Create New User (Sign Up/register User)
    def post(self):
        json_data = request.get_json(force=True)

        if not json_data:
            return {'message': 'No input data provided'}, 400

        user = User.query.filter_by(username=json_data['username']).first()
        if user:
            return {'message': 'Username is already taken'}, 409

        user = User.query.filter_by(
            emailaddress=json_data['emailaddress']).first()
        if user:
            return {'message': 'Email address already exists'}, 409

        api_key = self.generate_key()

        user = User.query.filter_by(api_key=api_key).first()
        if user:
            return {'message': 'API key already exists'}, 409

        user = User(
            api_key=api_key,
            firstname=json_data['firstname'],
            lastname=json_data['lastname'],
            phonenumber=json_data['phonenumber'],
            avatar=json_data['avatar'],
            emailaddress=json_data['emailaddress'],
            password=json_data['password'],
            username=json_data['username'],
        )
        db.session.add(user)
        db.session.commit()

        result = User.serialize(user)

        return {"status": 'success', 'data': result}, 201

    #Update User Profile
    def put(self):
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)
        if not header:
            return {'Messege': "No API key!"}, 401
        else:
            user = User.query.filter_by(api_key=header).first()
            if user:
                if user.password != json_data["currentPassword"]:
                    return {"Message": "Incorrect Current Password"}
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
                return {'Messege': "No User found with that api key"}, 404

    #Generate new api key
    def generate_key(self):
        return ''.join(
            random.choice(string.ascii_letters + string.digits)
            for _ in range(50))