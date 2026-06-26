import time

count = 0

while True:
    with open("/data/output.txt", "a") as file:
        file.write(f"Writing line {count}\n")

    print(f"Wrote line {count}", flush=True)

    count += 1

    time.sleep(5)
