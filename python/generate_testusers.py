import csv
import random

first_names = ["Test"]
last_names = ["Mueller", "Schmidt", "Fischer", "Weber", "Wagner", "Becker", "Hoffmann"]
departments = ["IT", "HR", "Sales"]

used_usernames = set()

with open(r"C:\Lab\data\testusers.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["FirstName", "LastName", "Department", "Username"])

    for i in range(4):
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        department = random.choice(departments)

        base_username = f"{first_name[0].lower()}.{last_name.lower()}"
        username = base_username
        counter = 1

        while username in used_usernames:
            username = f"{base_username}{counter}"
            counter += 1

        used_usernames.add(username)

        writer.writerow([first_name, last_name, department, username])

print("users.csv wurde erstellt.")
