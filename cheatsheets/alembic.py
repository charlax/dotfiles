import sqlalchemy as sa
from alembic import operations as op


def upgrade() -> None:
    # Set column as not nullable
    op.alter_column(
        "table_name",
        "column_name",
        existing_type=sa.VARCHAR(),
        nullable=False,
        schema="schema_name",
    )
