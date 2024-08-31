class Notifier:
    def __init__(self, config):
        self.config = config

    def send_notification(self, report):
        # 根据配置发送通知，例如通过邮件或Slack
        print("发送通知: ", report)
