#!/usr/bin/env python

import os
import signal
import urllib

def handler(signum, frame):
    raise RuntimeError("Alarm")
signal.signal(signal.SIGALRM, handler)

def update_louds():
    if os.fork():
        signal.alarm(3)
        print urllib.urlopen("http://isuckatdomains.net:3168/loud.pl").read()
    else:
        signal.alarm(45)
        louds = []
        for i in range(10):
            louds.append(urllib.urlopen("http://isuckatdomains.net:3168/loud.pl").read())

        with open(os.getenv("HOME") + "/.louds-new", "w") as f:
            for loud in louds:
                f.write(loud.strip() + "\n")

        os.rename(os.getenv("HOME") + "/.louds-new", os.getenv("HOME") + "/.louds")
    

try:
    with open(os.getenv("HOME") + "/.louds") as f:
        louds = list(f)

    if len(louds) < 5:
        update_louds()
    else:
        print louds[0]
        with open(os.getenv("HOME") + "/.louds-new", "w") as f:
            for loud in louds[1:]:
                f.write(loud.strip() + "\n")
        os.rename(os.getenv("HOME") + "/.louds-new", os.getenv("HOME") + "/.louds")
        

except IOError:
    try:
        update_louds()
    except RuntimeError:
        pass    
except RuntimeError:
    pass    
