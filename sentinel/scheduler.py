import schedule
import time
import threading

class TaskScheduler:
    def __init__(self):
        self.jobs = []

    def add_daily_task(self, task_func, time_str):
        """添加每日执行的任务"""
        job = schedule.every().day.at(time_str).do(task_func)
        self.jobs.append(job)

    def add_weekly_task(self, task_func, day_of_week, time_str):
        """添加每周执行的任务"""
        job = schedule.every().week.do(task_func)
        getattr(job, day_of_week).at(time_str)
        self.jobs.append(job)

    def start(self):
        """开始任务调度"""
        thread = threading.Thread(target=self._run)
        thread.start()

    def _run(self):
        while True:
            schedule.run_pending()
            time.sleep(1)
