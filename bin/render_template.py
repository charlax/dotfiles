#!/usr/bin/env python3

"""

Dependencies:

- fd
- fzf

Example template:

Filename: "Template Interview {name}.md"

```markdown
# Interview with

Name: {name}
```

Variables:

- `today` replaced with date, e.g. '2023-01-01'
- `now` replace with date and time, e.g. '2023-01-01 15:35'

Uses:

- Interview notes

"""

import argparse
import csv
import itertools as it
import io
import os
import re
import subprocess
import sys
from datetime import datetime
from functools import reduce
from pathlib import Path
from typing import Dict, Set, Any, List, Optional
from string import Formatter

# This script has no dependency (e.g., jinja). (jinja mentioned here for
# grepping)


def prompt(name: str) -> str:
    value = input(f"{name.strip()}: ")
    return value


def clean_template(template: str) -> str:
    # Clean up variables (some have space before them)
    # Exclude double curly (which is the way to escape)
    # https://docs.python.org/3/library/string.html#format-string-syntax
    pattern = r"(?<!{)\{\s*([^{}]+?)\s*\}(?!})"
    return re.sub(pattern, r"{\1}", template)


def get_base_context() -> Dict[str, Any]:
    return {
        "today": datetime.now().strftime("%Y-%m-%d"),
        "now": datetime.now().strftime("%Y-%m-%d %H:%M"),
    }


def get_context(names: Set[str], base: Dict[str, str]) -> Dict[str, str]:
    """Get context variables."""

    def reducer(acc: Dict[str, str], name: str) -> Dict[str, str]:
        value = prompt(name)
        acc[name] = value
        return acc

    return reduce(reducer, sorted(names), base)


def get_required_variables(template: str) -> List[str]:
    parsed = Formatter().parse(template)
    return list(filter(None, [fieldname for _, fieldname, _, _ in parsed]))


def choose_template(dir: Path) -> Path:
    """Let the user choose from one template from folder."""
    ls = subprocess.Popen(["fd", ".", str(dir)], stdout=subprocess.PIPE)
    r = (
        subprocess.check_output(
            ["fzf", "--delimiter", "/", "--with-nth", "-1"], stdin=ls.stdout
        )
        .decode("utf-8")
        .strip()
    )
    returned = Path(r)
    if not returned.exists():
        raise OSError(f"File {returned} does not exist")
    return returned


def get_editor_cmd(editor: str) -> List[str]:
    """Get editor command."""
    if editor == "ia":
        return ["open", "-a", "IA Writer"]
    return [editor]


def get_filename(filename_template: str, context: Dict[str, str]) -> Path:
    """Return filename for the rendered template."""
    return Path(
        filename_template.format(**context)
        .replace("template", "")
        .replace("Template", "")
        .replace("..", ".")
        .strip()
    )


def get_rendered_content(template: str, context: Dict[str, str]) -> str:
    return template.format(**context)


def write_file(rendered: str, filename: Path) -> None:
    """Write the file."""
    if filename.exists():
        raise OSError(f"File {filename} already exists")

    with open(filename, "w") as f:
        f.write(rendered)


def get_frontmatter_params(content: str) -> Dict[str, str]:
    """Parse frontmatter."""
    params = {}
    lines = content.split("\n")

    if not lines[0] == "---":
        return params

    end_index = lines.index("---", 1)
    frontmatter = lines[1:end_index]

    for line in frontmatter:
        if ": " not in line:
            continue

        key, value = line.split(": ", 1)

        if key.strip() == "template_post":
            params[key.strip()] = value.strip()

    return params


def run_hooks(params: Dict[str, str]) -> None:
    if "template_post" in params:
        subprocess.run(params["template_post"], shell=True, check=True)


def main(
    template: Path, editor: str = "", csvfile: Optional[io.TextIOWrapper] = None
) -> int:
    template_path = choose_template(template) if template.is_dir() else template
    print(f"template_path: {template_path}")
    filename_template = str(template_path.name)

    with open(template_path) as f:
        content_template = clean_template(f.read(100000))

    base_context = get_base_context()

    required_variables = set(
        it.chain.from_iterable(
            map(get_required_variables, [filename_template, content_template])
        )
    ) - set(base_context.keys())

    if csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            context = {**base_context, **row}
            filename = get_filename(filename_template, context)
            rendered = get_rendered_content(content_template, context)
            write_file(rendered, filename)

    else:
        context = get_context(required_variables, base_context)
        filename = get_filename(filename_template, context)
        rendered = get_rendered_content(content_template, context)

        params = get_frontmatter_params(rendered)

        write_file(rendered, filename)

        run_hooks(params)

        print(str(filename))

        if editor:
            editor_parsed = get_editor_cmd(editor)
            subprocess.Popen([*editor_parsed, str(filename)])

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="render a template file")
    parser.add_argument("template", help="template filename or folder")
    parser.add_argument(
        "-e",
        "--editor",
        help="editor",
        default=os.environ["EDITOR"],
    )
    parser.add_argument(
        "--csv",
        help="CSV with template variables",
        type=argparse.FileType("r"),
    )

    args = parser.parse_args()

    sys.exit(main(template=Path(args.template), editor=args.editor, csvfile=args.csv))
