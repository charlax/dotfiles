#!/usr/bin/env python3
"""
Convert JSON database schema to Mermaid ER diagram.
"""

import json
import sys
import re
from typing import Dict, List, Any


def sanitize_type(text: str) -> str:
    """Sanitize column types for Mermaid ER diagrams."""
    # Remove parentheses and other problematic characters from types
    return re.sub(r"[^a-zA-Z0-9]", "", text)


def sanitize_identifier(text: str) -> str:
    """Sanitize identifiers for Mermaid ER diagrams."""
    # Replace problematic characters with underscores
    return re.sub(r"[^a-zA-Z0-9_]", "_", text)


def format_column(column: Dict[str, Any]) -> str:
    """Format a single column for ER diagram."""
    name: str = column.get("name", "")
    col_type: str = column.get("type", "")
    nullable: bool = column.get("nullable", True)
    primary_key: bool = column.get("primaryKey", False)

    # Sanitize identifiers
    clean_name = sanitize_identifier(name)
    clean_type = sanitize_type(col_type)

    # Build column string: "type name constraint"
    constraint = ""
    if primary_key:
        constraint = " PK"
    elif not nullable:
        constraint = " NOT_NULL"

    return f"{clean_type} {clean_name}{constraint}"


def generate_er_diagram(tables: List[Dict[str, Any]]) -> str:
    """Generate Mermaid ER diagram from tables."""
    lines: List[str] = ["erDiagram"]

    for table in tables:
        table_name: str = table.get("name", "")
        columns: List[Dict[str, Any]] = table.get("columns", [])

        # Sanitize table name
        clean_table_name = sanitize_identifier(table_name)
        lines.append(f"  {clean_table_name} {{")

        for column in columns:
            formatted_column = format_column(column)
            lines.append(f"    {formatted_column}")

        lines.append("  }")

    return "\n".join(lines)


def main():
    """Main function."""
    if len(sys.argv) != 2:
        print("Usage: python json_to_mermaid.py <json_file>")
        sys.exit(1)

    filename: str = sys.argv[1]

    try:
        with open(filename, "r") as f:
            data: Dict[str, Any] = json.load(f)
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON: {e}")
        sys.exit(1)

    tables: List[Dict[str, Any]] = data.get("tables", [])
    diagram: str = generate_er_diagram(tables)
    print(diagram)


if __name__ == "__main__":
    main()
