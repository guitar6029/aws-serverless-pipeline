# from http.server import HTTPServer, BaseHTTPRequestHandler
# import os

# service_name = os.getenv("SERVICE_NAME", "Unknown Service Name")


# class Handler(BaseHTTPRequestHandler):
#     def do_GET(self):
#         self.send_response(200)
#         self.end_headers()
#         self.wfile.write(service_name.encode())


# server = HTTPServer(("0.0.0.0", 8000), Handler)

# print("Server started", flush=True)

# server.serve_forever()

import time

print("Starting...", flush=True)
time.sleep(5)
raise Exception("boom")
