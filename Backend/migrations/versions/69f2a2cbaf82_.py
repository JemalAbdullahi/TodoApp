"""empty message

Revision ID: 69f2a2cbaf82
Revises: 6ee477a158a7
Create Date: 2021-06-20 16:19:25.707256

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '69f2a2cbaf82'
down_revision = '6ee477a158a7'
branch_labels = None
depends_on = None


def upgrade():
    op.rename_table('USER_ASSIGNED_TO_SUBTASK', 'user_assigned_to_subtask')


def downgrade():
    op.rename_table('user_assigned_to_subtask', 'USER_ASSIGNED_TO_SUBTASK')
