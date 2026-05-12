# tests/helpers/constants.py
"""Shared test constants for O‑Frame."""

class TestConstants:
    """Timeouts and default values for tests."""

    # Timeouts (seconds)
    DEFAULT_TIMEOUT = 5.0
    SHORT_TIMEOUT = 1.0
    LONG_TIMEOUT = 10.0

    # Profit scoring thresholds
    MIN_PROFIT_SCORE = 1
    MAX_PROFIT_SCORE = 5
    GOLDEN_IDEA_THRESHOLD = 4

    # Test data
    SAMPLE_QUESTION = "How to make $100 fast?"
    SAMPLE_ANSWER = "Sell unused items on eBay."
    SAMPLE_PROFIT_SCORE = 3
