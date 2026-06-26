# from redis_client import client
# from redis_queue import RedisQueue
# import time

# JOB_QUEUE = "telemetry-jobs"

# telemetry_queue = RedisQueue(client, JOB_QUEUE)

# print("Worker started")

# while True:
#     query_name, job = telemetry_queue.pop()

#     print(f"Received from {query_name}: {job}")

#     print("Processing...")

#     time.sleep(3)

#     print("Done!\n")


print("=== WORKER BOOTING ===", flush=True)

from redis_client import client
from redis_queue import RedisQueue
import time

print("=== IMPORTS DONE ===", flush=True)

JOB_QUEUE = "telemetry-jobs"

telemetry_queue = RedisQueue(client, JOB_QUEUE)

print("=== REDIS CONNECTED ===", flush=True)

while True:
    print("Waiting...", flush=True)

    queue_name, job = telemetry_queue.pop()

    print(f"Received {job}", flush=True)
