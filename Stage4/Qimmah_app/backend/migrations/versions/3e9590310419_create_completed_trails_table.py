"""create completed trails table

Revision ID: 3e9590310419
Revises: c404d1171e01
Create Date: 2026-10-27 08:39:03.863569

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '3e9590310419'
down_revision = 'c404d1171e01'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('completed_trails',
    sa.Column('userId', sa.Integer(), nullable=False),
    sa.Column('trailId', sa.Integer(), nullable=False),
    sa.Column('completedAt', sa.DateTime(), server_default=sa.text('now()'), nullable=True),
    sa.ForeignKeyConstraint(['trailId'], ['trails.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['userId'], ['users.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('userId', 'trailId')
    )


def downgrade():
    op.drop_table('completed_trails')
