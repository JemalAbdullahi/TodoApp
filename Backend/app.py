from Models import db
from api.api import api_bp
import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import sys
import logging


app = Flask(__name__)
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.ERROR)

app.config.from_object(os.environ['APP_SETTINGS'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

app.register_blueprint(api_bp, url_prefix='/api')

db.init_app(app)


@app.route('/')
def index():
    return "<h1>Welcome to our server !!</h1>"


if __name__ == "__main__":
    app.run(debug=True)
