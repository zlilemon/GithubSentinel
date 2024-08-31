#!/bin/bash

# 创建项目目录结构
mkdir -p github-sentinel/{sentinel,config,tests}

# 生成 README.md 文件
cat <<EOL > github-sentinel/README.md
# GitHub Sentinel

GitHub Sentinel is an open-source tool for developers and project managers that periodically fetches and summarizes the latest updates from subscribed GitHub repositories.

## Features
- Subscription Management
- Update Fetching
- Notification System
- Report Generation

## Setup
\`\`\`
pip install -r requirements.txt
\`\`\`

## Usage
\`\`\`
python sentinel/main.py
\`\`\`
EOL

# 生成 requirements.txt 文件
cat <<EOL > github-sentinel/requirements.txt
schedule
requests
PyYAML
EOL

# 生成 config/config.yaml 文件
cat <<EOL > github-sentinel/config/config.yaml
subscriptions:
  - owner/repo1
  - owner/repo2

notifier:
  email: example@example.com

report:
  format: text
EOL

# 生成 sentinel/__init__.py 文件
touch github-sentinel/sentinel/__init__.py

# 生成 sentinel/main.py 文件
cat <<EOL > github-sentinel/sentinel/main.py
from subscription import SubscriptionManager
from fetcher import UpdateFetcher
from notifier import Notifier
from reporter import ReportGenerator
from scheduler import TaskScheduler
import utils

def run():
    # 加载配置
    config = utils.load_config("config/config.yaml")

    # 初始化模块
    sub_manager = SubscriptionManager(config["subscriptions"])
    fetcher = UpdateFetcher()
    notifier = Notifier(config["notifier"])
    reporter = ReportGenerator(config["report"])
    scheduler = TaskScheduler()

    # 定义每日任务
    def daily_task():
        repos = sub_manager.get_subscriptions()
        updates = fetcher.fetch_updates(repos)
        report = reporter.generate_report(updates)
        notifier.send_notification(report)

    # 添加定时任务
    scheduler.add_daily_task(daily_task, "09:00")  # 每天早上 9 点执行

    # 开始任务调度
    scheduler.start()

if __name__ == "__main__":
    run()
EOL

# 生成 sentinel/scheduler.py 文件
cat <<EOL > github-sentinel/sentinel/scheduler.py
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
EOL

# 生成 sentinel/subscription.py 文件
cat <<EOL > github-sentinel/sentinel/subscription.py
class SubscriptionManager:
    def __init__(self, subscriptions):
        self.subscriptions = subscriptions

    def add_subscription(self, repo):
        if repo not in self.subscriptions:
            self.subscriptions.append(repo)
            # 持久化更新（可选）

    def remove_subscription(self, repo):
        if repo in self.subscriptions:
            self.subscriptions.remove(repo)
            # 持久化更新（可选）

    def get_subscriptions(self):
        return self.subscriptions
EOL

# 生成 sentinel/fetcher.py 文件
cat <<EOL > github-sentinel/sentinel/fetcher.py
import requests

class UpdateFetcher:
    def __init__(self):
        self.api_base_url = "https://api.github.com"

    def fetch_updates(self, repos):
        updates = {}
        for repo in repos:
            updates[repo] = self.get_repo_updates(repo)
        return updates

    def get_repo_updates(self, repo):
        # 调用 GitHub API 获取仓库的最新提交
        response = requests.get(f"{self.api_base_url}/repos/{repo}/commits")
        if response.status_code == 200:
            return response.json()
        return []
EOL

# 生成 sentinel/notifier.py 文件
cat <<EOL > github-sentinel/sentinel/notifier.py
class Notifier:
    def __init__(self, config):
        self.config = config

    def send_notification(self, report):
        # 根据配置发送通知，例如通过邮件或Slack
        print("发送通知: ", report)
EOL

# 生成 sentinel/reporter.py 文件
cat <<EOL > github-sentinel/sentinel/reporter.py
class ReportGenerator:
    def __init__(self, config):
        self.config = config

    def generate_report(self, updates):
        # 生成格式化报告
        report = "最新仓库更新报告：\n"
        for repo, update in updates.items():
            report += f"仓库: {repo}\n"
            for commit in update:
                report += f"- {commit['commit']['message']}\n"
        return report
EOL

# 生成 sentinel/utils.py 文件
cat <<EOL > github-sentinel/sentinel/utils.py
import yaml

def load_config(config_path):
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)
EOL

# 生成 tests/test_scheduler.py 文件
cat <<EOL > github-sentinel/tests/test_scheduler.py
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
EOL

echo "项目结构和文件已成功生成！"

