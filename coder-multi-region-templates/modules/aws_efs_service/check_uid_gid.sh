#!/bin/bash

# Check if UID 1000 exists
if id -u 1000 &>/dev/null; then
  echo "{\"uid\": 1000, \"gid\": 1000}"
else
  echo "{\"uid\": 1001, \"gid\": 1001}"
fi
