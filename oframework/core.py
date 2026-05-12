def profit_score(text: str) -> int:
    """Return a profit score for the given text."""
    if "free cheap" in text:
        return 1
    return 0
