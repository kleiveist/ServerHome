#!/bin/bash

# Definition of the log_message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Display contents of /etc/hosts file
echo "📁 Contents of /etc/hosts:"
echo "-----------------------------"
cat /etc/hosts
echo "+----------------------------------------------------+"