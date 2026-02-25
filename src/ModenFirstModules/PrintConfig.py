import sys
import time

def slow_print(text, delay=0.03, enddelay=0.3):
    """문자를 하나씩 천천히 출력합니다."""
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()
    time.sleep(enddelay)
