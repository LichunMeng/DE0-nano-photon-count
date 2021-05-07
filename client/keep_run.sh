#!/bin/bash
process="my_FIFO"
makerun="/etc/init.d/my_FIFO restart"
if ps ax | grep -v grep | grep -v bash | grep --quiet $process
then
    printf "Process '%s' is running.\n" "$process"
    exit
else
    printf "Starting process '%s' with command '%s'.\n" "$process" "$makerun"
    $makerun
fi
exit

