"""add review reports

Revision ID: 9b1f4c2d7a10
Revises: 6c315eca3e67
Create Date: 2026-11-25 12:00:00

"""
from alembic import op
import sqlalchemy as sa

revision = '9b1f4c2d7a10'
down_revision = '6c315eca3e67'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'review_reports',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('review_id', sa.Integer(), nullable=False),
        sa.Column('reporter_id', sa.Integer(), nullable=False),
        sa.Column('reason', sa.String(length=30), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now(), nullable=True),
        sa.ForeignKeyConstraint(['review_id'], ['reviews.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['reporter_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('review_id', 'reporter_id', name='uq_report_review_reporter'),
    )


def downgrade():
    op.drop_table('review_reports')
