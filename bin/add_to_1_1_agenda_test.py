from add_to_1_1_agenda import maybe_add_next, add_next_item

# Run with:
# uv pip install pytest
# source .venv/bin/activate
# pytest bin/add_to_1_1_agenda_test.py


def test_maybe_add_next_when_absent():
    lines = ["---", "title: Sample Document", "---", "Some initial text."]
    expected = [
        "---",
        "title: Sample Document",
        "---",
        "Some initial text.",
        "",
        "## Next",
        "",
    ]
    result = maybe_add_next(lines)
    assert result == expected


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
    ]
    result = maybe_add_next(lines)
    expected = [
        "---",
        "title: Sample Document",
        "---",
        "## Recurring",
        "Item 1",
        "Item 2",
        "",
        "## Next",
        "",
    ]

    assert result == expected


def test_maybe_add_next_after_recurring_with_emoji():
    lines = [
        "# Title",
        "",
        "## ➡️  Recurring",
        "- Item 2",
    ]
    expected = [
        "# Title",
        "",
        "## ➡️  Recurring",
        "- Item 2",
        "",
        "## Next",
        "",
    ]

    result = maybe_add_next(lines)

    assert result == expected


def test_next_after_note_body():
    lines = ["# Title", "", "Hello world"]
    result = maybe_add_next(lines)
    result = add_next_item(result, "Do something")
    expected = [
        "# Title",
        "",
        "Hello world",
        "",
        "## Next",
        "",
        "- Do something",
    ]

    assert result == expected


def test_next_after_recurring_with_space():
    lines = [
        "# Title",
        "",
        "## Recurring",
        "",
        "- Item 1",
    ]
    result = maybe_add_next(lines)
    result = add_next_item(result, "Do something")
    expected = [
        "# Title",
        "",
        "## Recurring",
        "",
        "- Item 1",
        "",
        "## Next",
        "",
        "- Do something",
    ]

    assert result == expected


def test_add_next_with_existing_date_section():
    lines = [
        "# Title",
        "",
        "## May 06, 2024",
    ]
    result = maybe_add_next(lines)
    result = add_next_item(result, "Do something")
    expected = [
        "# Title",
        "",
        "## Next",
        "",
        "- Do something",
        "",
        "## May 06, 2024",
    ]

    assert result == expected


def test_next_after_recurring_with_existing_next():
    lines = [
        "# Title",
        "",
        "## Recurring",
        "",
        "- Item 1",
        "",
        "## Next",
        "",
        "- Add 1",
        "",
        "## May 06, 2024",
    ]
    result = maybe_add_next(lines)
    result = add_next_item(result, "Do something")
    expected = [
        "# Title",
        "",
        "## Recurring",
        "",
        "- Item 1",
        "",
        "## Next",
        "",
        "- Do something",
        "- Add 1",
        "",
        "## May 06, 2024",
    ]

    assert result == expected
