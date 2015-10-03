#!/usr/bin/env bash

scriptLocation="$( cd "$( dirname "$0" )" && pwd )"
pidFile="$scriptLocation/.lockPendrive.pid"
checkSdb=$(sudo blkid | grep "/dev/sdb" | cut -d ':' -f1)
checkID=$(sudo blkid | grep "/dev/sdb" | cut -d '"' -f2)

runLocker() {
	pidValue=$(ps ax | grep "pendriveLocker" | grep -v grep | awk '{ print $1 }')
	echo "$pidValue" > "$pidFile"
	while true; do
		if [[ ! -b "/dev/sdb" ]]; then
			if [[ "$checkSdb" == "/dev/sdb" && "$checkID" == "EFC8-DD19" ]]; then
				gnome-screensaver-command -a
			fi
		else
			gnome-screensaver-command -d
			continue
		fi
	done
}

stopLocker() {

	if [[ -f "$pidFile" ]]; then
		cat "$pidFile" | while read deletePid; do
			kill "$deletePid" > /dev/null 2>&1
		done
		rm "$pidFile"
	fi

}

case "$1" in
	start)
		runLocker &
		;;
	stop)
		stopLocker
		;;
	*)
		echo "Usage : pendriveLocker {start|stop}"
		;;
esac

