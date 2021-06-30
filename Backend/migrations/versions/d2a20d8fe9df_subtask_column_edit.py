"""Subtask Column edit

Revision ID: d2a20d8fe9df
Revises: e823be1ebca7
Create Date: 2021-06-30 14:48:28.282068

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd2a20d8fe9df'
down_revision = 'e823be1ebca7'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('subtasks', 'group')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('subtasks', sa.Column('group', sa.VARCHAR(), autoincrement=False, nullable=False))
    # ### end Alembic commands ###
