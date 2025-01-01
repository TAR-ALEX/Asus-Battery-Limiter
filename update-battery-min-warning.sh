#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
UPOWER_CONF="/etc/UPower/UPower.conf"

# Print usage instructions
usage() {
    echo -e "${YELLOW}Usage: $0 --low <percentage> --critical <percentage> --action <percentage>${NC}"
    echo -e "${YELLOW}Example: $0 --low 40 --critical 30 --action 20${NC}"
    exit 1
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    usage
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --low)
            LOW=$2
            shift 2
            ;;
        --critical)
            CRITICAL=$2
            shift 2
            ;;
        --action)
            ACTION=$2
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate arguments
if [[ -z "$LOW" || -z "$CRITICAL" || -z "$ACTION" ]]; then
    echo -e "${RED}Error: Missing required arguments.${NC}"
    usage
fi

# Function to update or add a configuration value
update_or_add_value() {
    local key=$1
    local value=$2
    if grep -q "^$key=" "$UPOWER_CONF"; then
        # Update the existing value
        sudo sed -i "s/^$key=.*/$key=$value/" "$UPOWER_CONF"
    else
        # Add the new value
        echo "$key=$value" | sudo tee -a "$UPOWER_CONF" > /dev/null
    fi
}

# Ensure the mode is set to percentage
echo -e "${GREEN}Setting UsePercentageForPolicy to true...${NC}"
update_or_add_value "UsePercentageForPolicy" "true"

# Update or add the values
echo -e "${GREEN}Updating UPower.conf with new values...${NC}"
update_or_add_value "PercentageLow" "$LOW"
update_or_add_value "PercentageCritical" "$CRITICAL"
update_or_add_value "PercentageAction" "$ACTION"

echo -e "${GREEN}Done!${NC}"
