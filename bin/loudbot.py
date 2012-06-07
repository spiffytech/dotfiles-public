#!/usr/bin/env python

import signal
import urllib

def handler(signum, frame):
    raise Exception("Alarm")
signal.signal(signal.SIGALRM, handler)
signal.alarm(3)

try:
    print urllib.urlopen("http://isuckatdomains.net:3168/loud.pl").read()
except:
    pass
