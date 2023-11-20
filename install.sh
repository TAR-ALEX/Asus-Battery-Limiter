#!/bin/bash

# Check for root permissions
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create directory if it doesn't exist
DIR="/opt/battery_limit"
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
fi

# Create the battery_limiter.sh file
cat <<'EOF' > /opt/battery_limit/battery_limiter.sh
#!/bin/bash

declare file="/sys/class/power_supply/BAT1/charge_control_end_threshold"
declare target=$( cat "/opt/battery_limit/battery_limit" )

declare file_content=$( cat "${file}" )

if ! [[ " $file_content " =~ $target ]]
    then
        echo ${target} > ${file}
        #echo "bad"
    #else
        #echo "good"
        
fi

exit
EOF

# Create the battery_limit file
echo "80" > /opt/battery_limit/battery_limit

# Set permissions
chmod 777 /opt/battery_limit/battery_limiter.sh
chmod 777 /opt/battery_limit/battery_limit

# Add cron jobs
(crontab -l ; echo "* * * * * /opt/battery_limit/battery_limiter.sh") | sort - | uniq - | crontab -
(crontab -l ; echo "@reboot /opt/battery_limit/battery_limiter.sh") | sort - | uniq - | crontab -

# Restart cron service
sudo service cron restart

echo "Setup complete."
