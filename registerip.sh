#!/bin/bash


# config
logdir=/opt/ddnss/log
progdir=/opt/ddnss

currentip6=$(curl -6 -s --connect-timeout 5 https://api.myip.com | jq '.ip')
currentip4=$(curl -4 -s --connect-timeout 5 https://api.myip.com | jq '.ip')
lastip6=$(cat $progdir/lastip6.txt)
lastip4=$(cat $progdir/lastip4.txt)

ipv6=false
ipv4=false

if [ ! -d "$logdir" ]; then
    mkdir $logdir
fi

if [ -z $currentip6 ]; then
    echo no current ipv6 address found, waiting...
    exit
fi
if [ -z $currentip4 ]; then
    echo no current ipv4 address found, waiting...
    exit
fi

echo ipv6
echo $currentip6 vs $lastip6
if [[ "$currentip6" == "$lastip6" ]]; then
    echo ipv6 has not changed
else
    ipv6=true
    echo ipv6 has changed
fi

echo
echo ipv4
echo $currentip4 vs $lastip4
if [[ "$currentip4" == "$lastip4" ]]; then
    echo ipv4 has not changed
else
    ipv4=true
    echo ipv4 has changed
fi

echo

if [[ "$ipv4" == true ||  "$ipv6" == true ]]; then

    echo calling ddnss to update ips to $currentip4 and $currentip6
    
    # saving ip addresses
    echo $currentip4 > $progdir/lastip4.txt
    echo $currentip6 > $progdir/lastip6.txt

    # encoding ipv6 url
    currentip6=${currentip6//:/%3A}

    # removing "
    currentip6=${currentip6//\"/}
    currentip4=${currentip4//\"/}

    # adding ipv4 to the connection string
    updateurl=$(cat $progdir/ddnss.url)
    updateurl=$updateurl\&ip=$currentip4\&ip6=$currentip6

    echo caller url = $updateurl
    echo $updateurl > $progdir/caller.url
#    xargs -n 1 curl -O < $progdir/ddnss.url 
    d=$(date +%Y%m%d%H%M)
    wget -4 -i $progdir/caller.url -q -O $logdir/confirmation-$d.html

else
    echo nothing to do. stopping.
fi

#rm -f upd.php*

