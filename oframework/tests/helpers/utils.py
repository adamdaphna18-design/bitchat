# tests/helpers/utils.py
"""Reusable test utilities."""
import json
import tempfile
from pathlib import Path
from unittest.mock import MagicMock

def create_temp_state_file(content: dict) -> Path:
    """Create a temporary .o/state.json file for testing."""
    temp_dir = tempfile.mkdtemp()
    state_path = Path(temp_dir) / ".o" / "state.json"
    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(json.dumps(content))
    return state_path

def mock_ollama_response(text: str, delay: float = 0):
    """Return a mock subprocess result for ask_ollama."""
    mock = MagicMock()
    mock.stdout = text
    mock.returncode = 0
    return mock

def mock_search_result(title: str, body: str, href: str):
    """Return a mock DuckDuckGo result dict."""
    return {"title": title, "body": body, "href": href}
