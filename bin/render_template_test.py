"""Tests for render_template

Run with:

uv run pytest bin/render_template_test.py
"""

import io

import pytest

from render_template import clean_template, main


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ("hello {now}", "hello {now}"),
        ("hello { now}", "hello {now}"),
        ("hello { now }", "hello {now}"),
    ],
)
def test_clean_template(test_input: str, expected: str) -> None:
    assert clean_template(test_input) == expected


def test_skip_column(tmp_path):
    template_content = """
    Filename: "Test {name}.txt"

    Name: {name}
    """.strip()

    template_file = tmp_path / "template.txt"
    template_file.write_text(template_content)

    csv_content = """name,skip
Alice,false
Bob,true
Charlie,false
""".strip()

    csv_file = io.StringIO(csv_content)

    main(template=template_file, csvfile=csv_file, skip_column="skip")

    # Expected files
    alice_file = tmp_path / "Test Alice.txt"
    bob_file = tmp_path / "Test Bob.txt"
    charlie_file = tmp_path / "Test Charlie.txt"

    assert alice_file.exists(), "Alice's file should be created."
    assert not bob_file.exists(), "Bob's file should be skipped."
    assert charlie_file.exists(), "Charlie's file should be created."
