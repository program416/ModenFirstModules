import sys
import time

def slow_print(text, delay=0.03, end_delay=0.3):
    """문자를 하나씩 천천히 출력합니다."""
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()
    time.sleep(end_delay)

def fast_print(text, end_delay=0.3):
    for char in text:
        print(char, end='')
    print()
    time.sleep(end_delay)