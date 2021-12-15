import unittest


class NumbersTest(unittest.TestCase):

    def test_multiply(self):
        self.assertEqual(2 * 2, 4)

    def test_divide(self):
        self.assertEqual(7 // 2, 3)

    def test_equal(self):
        self.assertEqual(1 + 1, 1)


if __name__ == '__main__':
    unittest.main()
