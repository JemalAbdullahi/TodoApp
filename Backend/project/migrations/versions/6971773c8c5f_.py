"""empty message

Revision ID: 6971773c8c5f
Revises: b8af3942ae90
Create Date: 2021-02-02 18:06:26.298941

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '6971773c8c5f'
down_revision = 'b8af3942ae90'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('avatar', sa.LargeBinary(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('users', 'avatar')
    # ### end Alembic commands ###