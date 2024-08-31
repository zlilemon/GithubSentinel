import unittest
from sentinel.scheduler import TaskScheduler

class TestTaskScheduler(unittest.TestCase):
    def test_add_daily_task(self):
        scheduler = TaskScheduler()
        scheduler.add_daily_task(lambda: print("Daily Task"), "09:00")
        self.assertEqual(len(scheduler.jobs), 1)

    def test_add_weekly_task(self):
        scheduler = TaskScheduler()
        scheduler.add_weekly_task(lambda: print("Weekly Task"), "monday", "10:00")
        self.assertEqual(len(scheduler.jobs), 1)

if __name__ == "__main__":
    unittest.main()
