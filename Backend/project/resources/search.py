from flask_restful import Resource
from flask import request
from Models import User
import random
import string


class Search(Resource):
    def post(self):
        result = []
        json_data = request.get_json(force=True)
        #header = request.headers["Authorization"]

        filtered_list = User.query.filter(
            User.username.startswith(json_data['search'])).all()
        if len(filtered_list) > 0:
            for user in filtered_list:
                result.append(User.serialize_public(user))

        return {"status": 'success', 'data': result}, 200