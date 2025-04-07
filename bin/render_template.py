#!/usr/bin/env -S uv -q run -s

# /// script
# dependencies = [
#   "jinja2",
# ]
# ///

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

from jinja2 import Environment, meta


jinja_env = Environment(trim_blocks=True, lstrip_blocks=True)


def get_bool(value: str) -> bool:
    return value.lower() in ("true", "1", "y", "on") if value else False


def extract_jinja2_variables(template_string: str) -> Set[str]:
    ast = jinja_env.parse(template_string)
    return set(meta.find_undeclared_variables(ast))


def is_jinja_template(content: str) -> Optional[bool]:
    # Patterns characteristic of Jinja2 templates
    jinja2_patterns = [
        r"{%.*?%}",  # Block statements
        r"{{.*?}}",  # Expressions to print
        r"{#.*?#}",  # Comments
    ]

    jinja2_score = sum(len(re.findall(pattern, content)) for pattern in jinja2_patterns)
    return jinja2_score > 1


def prompt(name: str) -> str:
    """Prompt the user for a value."""
    value = input(f"{name.strip()}: ")
    return value.strip()


def clean_template(template: str) -> str:
    """Clean up variables (some have space before them)."""
    # Exclude double curly (which is the way to escape)
    # https://docs.python.org/3/library/string.html#format-string-syntax
    pattern = r"(?<!{)\{\s*([^{}]+?)\s*\}(?!})"
    return re.sub(pattern, r"{\1}", template)


def get_base_context() -> Dict[str, Any]:
    """Return context items that are always available."""
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
    """Return required variables from template."""
    parsed = Formatter().parse(template)
    return list(filter(None, [fieldname for _, fieldname, _, _ in parsed]))


def choose_template(dir: Path) -> Path:
    """Let the user choose a template from a folder."""
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


def get_rendered_content(
    template: str, context: Dict[str, str], use_jinja: bool = False
) -> str:
    """Render the template content."""
    if use_jinja:
        return jinja_env.from_string(template).render(context)

    return template.format(**context)


def write_file(rendered: str, filename: Path) -> None:
    """Write the file."""
    if filename.exists():
        raise OSError(f"File {filename} already exists")

    with open(filename, "w") as f:
        f.write(rendered)


def parse_context(context: Dict[str, str], use_jinja: bool) -> Dict[str, Any]:
    """Parse booleans in context."""
    if not use_jinja:
        return context

    return {
        key: get_bool(value) if key.startswith(("is_", "has_")) else value
        for key, value in context.items()
    }


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
    template: Path,
    editor: str = "",
    csvfile: Optional[io.TextIOWrapper] = None,
    skip_column: Optional[str] = None,
    use_jinja: bool = False,
    list_variables: bool = False,
) -> int:
    template_path = choose_template(template) if template.is_dir() else template
    print(f"template_path: {template_path}", file=sys.stderr)
    filename_template = str(template_path.name)

    with open(template_path) as f:
        content_template = f.read(100000)

    # Infer if it is a jinja template
    if use_jinja is False:
        use_jinja = is_jinja_template(content_template)
        if use_jinja:
            print(
                "Template looks like Jinja2, switching to Jinja engine.",
                file=sys.stderr,
            )

    if not use_jinja:
        content_template = clean_template(content_template)

    base_context = get_base_context()

    # Get required variables
    content_variables = (
        extract_jinja2_variables(content_template)
        if use_jinja
        else get_required_variables(content_template)
    )
    required_variables = (
        set(content_variables) | set(get_required_variables(filename_template))
    ) - set(base_context.keys())

    if list_variables:
        print("\t".join(required_variables))
        return 0

    if csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if skip_column and get_bool(row.get(skip_column)) is True:
                continue

            context = {**base_context, **parse_context(row, use_jinja=use_jinja)}
            filename = get_filename(filename_template, context)
            rendered = get_rendered_content(
                content_template, context, use_jinja=use_jinja
            )
            write_file(rendered, filename)
            print(f"wrote file: {filename}")

    else:
        context = get_context(required_variables, base_context)
        filename = get_filename(filename_template, context)
        rendered = get_rendered_content(content_template, context, use_jinja=use_jinja)

        params = get_frontmatter_params(rendered)

        write_file(rendered, filename)

        run_hooks(params)

        print(str(filename))

        if editor:
            editor_parsed = get_editor_cmd(editor)
            subprocess.call([*editor_parsed, str(filename)])

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
    parser.add_argument(
        "-j",
        "--jinja",
        help="whether to use jinja2 for templating",
        action="store_true",
    )
    parser.add_argument(
        "-l",
        "--list-variables",
        help="extract variables from template",
        action="store_true",
    )
    parser.add_argument(
        "--skip-column",
        help="(with csv) name of column to use to skip records",
    )

    args = parser.parse_args()

    sys.exit(
        main(
            template=Path(args.template),
            editor=args.editor,
            csvfile=args.csv,
            use_jinja=args.jinja,
            list_variables=args.list_variables,
            skip_column=args.skip_column,
        )
    )
