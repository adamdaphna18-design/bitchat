import unittest
from oframework.core import profit_score
from . import TestConstants, mock_search_result

class TestProfitScore(unittest.TestCase):
    def test_profit_score_basic(self):
        # Use constant for threshold if needed
        score = profit_score("free cheap")
        self.assertEqual(score, TestConstants.MIN_PROFIT_SCORE)
