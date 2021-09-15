import json
from enum import Enum
from typing import Any
from uuid import UUID


def default(obj: Any) -> Any:
    if isinstance(obj, UUID):
        return str(obj)

    if issubclass(obj.__class__, Enum):
        return obj.value

    raise TypeError(f"Can't serialize {type(obj)}")


def dumps(*args: Any, **kwargs: Any) -> str:
    """Dump as json, supporting UUID and Enum."""
    kwargs.pop("default", None)
    return json.dumps(*args, **kwargs, default=default)
