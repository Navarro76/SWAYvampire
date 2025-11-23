#!/bin/sh
echo "The NAS server was shut down successfully on: $(date)" >> /home/alex/schedule-test-output.txt
/sbin/shutdown -h now
