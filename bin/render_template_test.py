import pytest

from render_template import clean_template


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
