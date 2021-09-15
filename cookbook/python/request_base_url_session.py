from typing import Optional
from urllib.parse import urljoin

from requests import Response, Session


class BaseUrlSession(Session):
    def __init__(  # type: ignore
        self, timeout: int, base_url: Optional[str] = None, *args, **kwargs
    ):
        super().__init__(*args, **kwargs)  # type: ignore
        self.base_url = base_url
        self.timeout = timeout

    def request(self, method: str, path: str, *args, **kwargs) -> Response:  # type: ignore
        if self.base_url:
            url = urljoin(self.base_url, path)
        else:
            url = path
        kwargs.setdefault("timeout", self.timeout)
        return super().request(method, url, *args, **kwargs)
