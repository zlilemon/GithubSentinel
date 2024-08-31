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
