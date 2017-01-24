#!/usr/bin/env python

import datetime
import time
import pytz

print datetime.datetime.fromtimestamp(time.time(), pytz.timezone('America/New_York')).isoformat()
