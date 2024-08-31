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
