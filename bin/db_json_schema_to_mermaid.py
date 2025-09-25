#!/usr/bin/env -S uv -q run -s
"""
Convert JSON database schema to Mermaid class diagram.
"""

import json
import sys
from typing import Dict, List, Any


def format_column(column: Dict[str, Any]) -> str:
    """Format a single column for class diagram."""
    name: str = column.get("name", "")
    col_type: str = column.get("type", "")
    nullable: bool = column.get("nullable", True)
    primary_key: bool = column.get("primaryKey", False)

    # Build column string: "type name modifiers"
    result = f"{col_type} {name}"

    modifiers: List[str] = []
    if not nullable:
        modifiers.append("NOT NULL")
    if primary_key:
        modifiers.append("PK")

    if modifiers:
        result += " " + " ".join(modifiers)

    return result


def generate_class_diagram(tables: List[Dict[str, Any]]) -> str:
    """Generate Mermaid class diagram from tables."""
    lines: List[str] = ["classDiagram", "  direction TB"]

    for table in tables:
        table_name: str = table.get("name", "")
        columns: List[Dict[str, Any]] = table.get("columns", [])

        lines.append(f"  class {table_name} {{")

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
    diagram: str = generate_class_diagram(tables)
    print(diagram)


if __name__ == "__main__":
    main()
