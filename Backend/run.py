""" from flask import Flask


def create_app(config_filename):
    app = Flask(__name__)
    app.config.from_object(config_filename)

    from app import api_bp
    app.register_blueprint(api_bp, url_prefix='/api')

    from Models import db
    db.init_app(app)

    return app

# Run
if __name__ == "__main__":
    app.run(debug=True)
 """
