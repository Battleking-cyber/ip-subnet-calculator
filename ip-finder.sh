#!/bin/bash
#============================================================#
#  IP Information Finder with Subnetting                     #
#                                                            #
#  Description : A utility to calculate network details      #
#                from a given IP address with CIDR.          #
#                Also supports subnetting calculations.      #
#                                                            #
#  Features    : - Network Address                           #
#                - Broadcast Address                         #
#                - First Usable IP                           #
#                - Last Usable IP                            #
#                - Subnetting with full subnet listing       #
#                                                            #
#  Author      : Pankaj A                                    #
#  Version     : 1.2 (Production Release)                    #
#  Date        : 2025-09-06                                  #
#============================================================#

# Check if ipcalc exists
if ! command -v ipcalc &>/dev/null; then
    echo "Error: ipcalc is not installed. Please install it first."
    exit 1
fi

# Prompt user for input
read -rp "Enter IP address with CIDR (e.g., 192.168.1.10/24): " ip_input

# Validate input format (basic check)
if [[ ! "$ip_input" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
    echo "Error: Invalid format. Example: 192.168.1.10/24"
    exit 1
fi

# Extract CIDR
cidr=$(echo "$ip_input" | cut -d/ -f2)

# Run ipcalc for base details
calc_output=$(ipcalc -n -b "$ip_input" 2>/dev/null)

if [[ $? -ne 0 ]]; then
    echo "Error: Failed to calculate IP details. Please check your input."
    exit 1
fi

# Extract details
network=$(echo "$calc_output" | grep "Network:" | awk '{print $2}')
broadcast=$(echo "$calc_output" | grep "Broadcast:" | awk '{print $2}')
hostmin=$(echo "$calc_output" | grep "HostMin:" | awk '{print $2}')
hostmax=$(echo "$calc_output" | grep "HostMax:" | awk '{print $2}')
total_hosts=$(( 2 ** (32 - cidr) - 2 ))

# Ask for subnetting
read -rp "Enter number of subnets you want: " subnets

if ! [[ "$subnets" =~ ^[0-9]+$ ]] || [[ "$subnets" -le 0 ]]; then
    echo "Error: Please enter a valid positive integer for subnets."
    exit 1
fi

# Calculate new subnet mask
needed_bits=0
while (( (1 << needed_bits) < subnets )); do
    ((needed_bits++))
done

new_cidr=$((cidr + needed_bits))
if (( new_cidr > 30 )); then
    echo "Error: Cannot create $subnets subnets from $ip_input (too small)."
    exit 1
fi

new_hosts=$(( (2 ** (32 - new_cidr)) - 2 ))

# Output summary
echo "============================================================"
echo "                 IP Information Finder"
echo "============================================================"
echo " Input IP       : $ip_input"
echo " Network ID     : $network"
echo " Broadcast ID   : $broadcast"
echo " First Usable   : $hostmin"
echo " Last Usable    : $hostmax"
echo " Total Hosts    : $total_hosts"
echo "------------------------------------------------------------"
echo " Subnetting"
echo " Requested Subs : $subnets"
echo " New CIDR       : /$new_cidr"
echo " Hosts/Subnet   : $new_hosts"
echo "============================================================"
echo " Listing All Subnets"
echo "============================================================"

# Use ipcalc to enumerate subnets
ipcalc "$network" "/$new_cidr" -s "$subnets"
if [[ $? -ne 0 ]]; then
    echo "Error: Could not calculate subnets."
    exit 1
fi

echo "============================================================"
echo " Author : Pankaj A"
echo "============================================================"
