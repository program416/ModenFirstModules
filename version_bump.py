import re
import sys

LEVELS = {
    "supermajor": 0,
    "major": 1,
    "minor": 2,
    "miniminor": 3,
    "hotfix": 4,
    "build": 5,
}

if len(sys.argv) < 2:
    sys.exit(1)

choice = sys.argv[1]

if choice == "skip":
    print("Skipping version update.")
    sys.exit(0)

if choice not in LEVELS:
    print("Invalid level")
    sys.exit(1)

with open("pyproject.toml", "r", encoding="utf-8") as f:
    content = f.read()

match = re.search(r'version\s*=\s*"([\d\.]+)"', content)
if not match:
    print("Version not found")
    sys.exit(1)

old_version = match.group(1)
parts = old_version.split(".")

while len(parts) < 6:
    parts.append("0")

parts = list(map(int, parts))
level = LEVELS[choice]

parts[level] += 1
for i in range(level + 1, 6):
    parts[i] = 0

new_version = ".".join(map(str, parts))

content = re.sub(
    r'version\s*=\s*"([\d\.]+)"',
    f'version = "{new_version}"',
    content,
)

with open("pyproject.toml", "w", encoding="utf-8") as f:
    f.write(content)

print(f"Version updated: {old_version} -> {new_version}")