
How to update the file sys_config.fex ?

After modified sys_config.fex ,excute the script update_sys_config.sh in the
directory boot-file.

If want to update the tfcar system ,use:
#./update_sys_config.sh tfcard 

If want to update the emmc system ,use:
#./update_sys_config.sh emmc 

Wait a moment.After executed it successful,please reboot the system.The
modification will be effective.
In order to prove the modification is effective ,you can change "heartbeat"to
"none".After the reboot ,the red LED is not bright.

If select wrong parameter,can't boot the system after reboot,so should execute
the script again with correct parameter.

