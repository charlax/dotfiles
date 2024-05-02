from add_to_1_1_agenda import maybe_add_next

# Run with:
# uv pip install pytest
# source .venv/bin/activate
# pytest bin/add_to_1_1_agenda_test.py


def test_add_next_when_absent():
    lines = ["---", "title: Sample Document", "---", "Some initial text."]
    expected = [
        "---",
        "title: Sample Document",
        "---",
        "",
        "## Next",
        "Some initial text.",
    ]
    result = maybe_add_next(lines)
    assert result == expected, "Should add ## Next correctly when absent"


def test_no_duplicate_next():
    lines = ["---", "title: Sample Document", "---", "## Next", "Some initial text."]
    result = maybe_add_next(lines)
    assert result.count("## Next") == 1, "Should not add a duplicate ## Next section"


def test_frontmatter_preservation():
    lines = ["---", "title: Sample Document", "---", "Some initial text."]
    result = maybe_add_next(lines)
    assert (
        result[0] == "---" and result[2] == "---"
    ), "Frontmatter should be preserved and intact"


def test_next_after_recurring():
    lines = [
        "---",
        "title: Sample Document",
        "---",
        "## Recurring",
        "Item 1",
        "Item 2",
        "Another header",
    ]
    result = maybe_add_next(lines)
    expected = [
        "---",
        "title: Sample Document",
        "---",
        "## Recurring",
        "Item 1",
        "Item 2",
        "Another header",
        "",
        "## Next",
    ]

    assert result == expected
