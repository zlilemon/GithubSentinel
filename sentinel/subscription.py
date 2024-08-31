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
