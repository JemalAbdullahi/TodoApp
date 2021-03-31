import os
import psycopg2

# You need to replace the next values with the appropriate values for your configuration
#Secret Key variable needs to be set to encrypt passwords

basedir = os.path.abspath(os.path.dirname(__file__))
os.environ[
    'DATABASE_URL'] = "postgres://hziyzkfjyqbkgt:ee4fb2d3bf48676497aeacc52b5cc3287ea28d31f82a61b02546a569b7342f0d@ec2-54-205-61-191.compute-1.amazonaws.com:5432/d3r4od0e955sl1"
SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = True
#SQLALCHEMY_DATABASE_URI = "postgresql://postgres:br1810ji@localhost/todo_appdb"

SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']

conn = psycopg2.connect(SQLALCHEMY_DATABASE_URI, sslmode='require')
