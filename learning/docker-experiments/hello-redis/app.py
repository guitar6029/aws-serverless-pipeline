import os
import redis
from flask import Flask, jsonify

HOST = "0.0.0.0"
PORT = 8000

app = Flask(__name__)


redis_host = os.getenv("REDIS_HOST", "redis")

r = redis.Redis(host=redis_host, port=6379, decode_responses=True)


def incrementer() -> int:
    return r.incr("visits")


@app.route("/reset-visits")
def reset_visits():
    r.delete("visits")
    return jsonify({"message": "Visits have been reset"})


@app.route("/visits")
def get_visits():
    count = incrementer()
    visit = {"total": count}
    return jsonify(visit)


if __name__ == "__main__":
    app.run(host=HOST, port=PORT)
