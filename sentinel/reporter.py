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
