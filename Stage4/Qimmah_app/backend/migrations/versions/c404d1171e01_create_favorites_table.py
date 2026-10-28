"""create favorites table

Revision ID: c404d1171e01
Revises: 358dfb27d4b9
Create Date: 2026-10-26 18:57:24.141021

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'c404d1171e01'
down_revision = '358dfb27d4b9'
branch_labels = None
depends_on = None

def upgrade():
    op.create_table('favorites',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('trail_id', sa.Integer(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=False),
    sa.ForeignKeyConstraint(['trail_id'], ['trails.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('user_id', 'trail_id', name='uq_favorite_user_trail')
    )


def downgrade():
    op.drop_table('favorites')
