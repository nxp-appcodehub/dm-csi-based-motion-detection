#
# Copyright 2025 NXP
#
# SPDX-License-Identifier: BSD-3-Clause
#

#!/bin/bash

# Start Python HTTP server in background
killall python3
python3 -m http.server 80 --bind 192.168.4.1 &

# Set default image
cp "./sensing.png" "./current.png"
sleep 2

# Start CSI event
./mlanutl mlan0 csi config/csi.conf

# Define thresholds
NEAR_THRESHOLD=-12.0
FAR_THRESHOLD=-15.0

# Start CSI stream and process one line at a time
unbuffer ./mlancsi mlan0 event config/mlancsi.conf | while read -r line; do
    value=$(echo "$line" | awk '{print $NF}')
    echo "CSI Value: $value"

    # Validate numeric value
    if [[ "$value" =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; then
        num_value=$(echo "$value" | bc -l)

        if (( $(echo "$num_value < 0 && $num_value >= $NEAR_THRESHOLD" | bc -l) )); then
            echo "Near motion detected"
            cp "./high-level-motion.png" "./current.png"
	elif (( $(echo "$num_value < -12 && $num_value > $FAR_THRESHOLD" | bc -l) )); then
            echo "Far motion detected"
            cp "./low-level-motion.png" "./current.png"
	else
            echo "Sensing state"
            cp "./sensing.png" "./current.png"
        fi
    fi

    sleep 0.5  # Delay before processing next CSI value
done
