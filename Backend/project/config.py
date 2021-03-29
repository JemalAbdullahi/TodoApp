import os
import psycopg2

# You need to replace the next values with the appropriate values for your configuration
#Secret Key variable needs to be set to encrypt passwords

basedir = os.path.abspath(os.path.dirname(__file__))
os.environ[
    'DATABASE_URL'] = "postgres://yzvvxujlwufluy:db0650d276c488bc408f04bd20252253202ab28121777007fdd4015d43fcd4a0@ec2-35-171-57-132.compute-1.amazonaws.com:5432/d188udg9kjd6u7"
SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = True
#SQLALCHEMY_DATABASE_URI = "postgresql://postgres:br1810ji@localhost/todo_appdb"

SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']

conn = psycopg2.connect(SQLALCHEMY_DATABASE_URI, sslmode='require')
