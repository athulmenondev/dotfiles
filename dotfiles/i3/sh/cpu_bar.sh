#!/bin/bash

cpu_percent=$(top -bn1 | awk '/^%Cpu\(s\):/ {print $2}' | sed 's/,//g')
filled_width=$(echo "$cpu_percent * 10 / 100" | bc)
empty_width=$((10 - filled_width))
bar=""
for i in $(seq 1 "$filled_width"); do
  bar+="█"
done
for i in $(seq 1 "$empty_width"); do
  bar+="░"
done
echo "CPU: $bar $cpu_percent%"
