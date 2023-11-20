# Asus-Battery-Limiter
Limit the battery max charge to preserve battery life. This works for Asus computers that can have their battery limit set with a path
`/sys/class/power_supply/BAT1/charge_control_end_threshold`
edit the path to tweak the utility.

Why is this needed? 

The machine forgets its battery limit configuration after reboot, this script will mitigate this flaw by periodically updating the battery limit.

Self installing script:

After intallation edit the file `/opt/battery_limit/battery_limit` to change the max charge rate.

Script is confirmed to work on an asus A15 tuf506
