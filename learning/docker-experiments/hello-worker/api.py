from flask import Flask, jsonify
from config import API_HOST, API_PORT
from redis_client import client
from redis_queue import RedisQueue

app = Flask(__name__)

JOB_QUEUE = "telemetry-jobs"

telemetry_queue = RedisQueue(client, JOB_QUEUE)


@app.route("/process")
def process():
    telemetry_queue.push("Process telemetry payload")
    return jsonify({"status": "Job queued"})


if __name__ == "__main__":
    app.run(host=API_HOST, port=API_PORT)
