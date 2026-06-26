from redis_client import client


class RedisQueue:

    def __init__(self, client, job_queue_name: str):
        self.client = client
        self.job_queue_name = job_queue_name

    def pop(self):
        queue_name, job = self.client.blpop(self.job_queue_name)
        return queue_name, job

    def push(self, job: str):
        self.client.rpush(self.job_queue_name, job)
