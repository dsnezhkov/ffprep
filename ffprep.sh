#!/bin/bash 


#
# This script 
# - removes some FF annoyances when dealing with proxying requests in intercepting proxy
# (e.g. removal of safe browsing and update checking)
# - sets up FF for proxying via Burp
# - creates a separate clean profile for testing 
# - downloads and helps install useful extensions  for hacking
# 
#


if [[ $# -ne 1 ]] 
then
	echo "Usage: $0 <profilename>"
	echo 
	exit 1
fi


FTOP="${HOME}/.mozilla/firefox"
FIREFOX="/usr/bin/firefox"

FPNAME=$1
FPROFILE="$FTOP/*.$FPNAME"

echo "-------------------- CONNECT ------------------"
echo "-------------------- $(date) ------------------"
echo "Cleaning FF profile $FPNAME (optional) ... "

if ls -d $FRPOFILE &> /dev/null -eq 0
then
    echo "$FPNAME profile is being removed  ... "
    rm -rf $FPROFILE
else
    echo "$FPNAME profile does not exist  ... "
fi


echo "Creating FF profile $FNAME... "
$FIREFOX -CreateProfile $FPNAME

pushd $FPROFILE

cat >>prefs.js <<DELIM
# disable junk redirects
user_pref("services.sync.prefs.sync.browser.safebrowsing.enabled", false);
user_pref("network.http.pipelining.ssl", false);
user_pref("network.prefetch-next", false) ;
user_pref("services.sync.prefs.sync.extensions.update.enabled", false);
user_pref("browser.urlbar.filter.javascript", false);

# setup proxy
user_pref("network.proxy.backup.ftp", "127.0.0.1");
user_pref("network.proxy.backup.ftp_port", 8080);
user_pref("network.proxy.backup.socks", "127.0.0.1");
user_pref("network.proxy.backup.socks_port", 8080);
user_pref("network.proxy.backup.ssl", "127.0.0.1");
user_pref("network.proxy.backup.ssl_port", 8080);
user_pref("network.proxy.ftp", "127.0.0.1");
user_pref("network.proxy.ftp_port", 8080);
user_pref("network.proxy.http", "127.0.0.1");
user_pref("network.proxy.http_port", 8080);
user_pref("network.proxy.share_proxy_settings", true);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 8080);
user_pref("network.proxy.socks_version", 4);
user_pref("network.proxy.ssl", "127.0.0.1");
user_pref("network.proxy.ssl_port", 8080);
user_pref("network.proxy.type", 1);
DELIM

popd


echo "Setting up extension environment ... "
if [[ ! -d $FPNAME ]]
then
  mkdir $FPNAME
fi

pushd $FPNAME

# Get firebug, greasmonkey, foxyproxy, useragentwitcher, add-n-edit cookies, flagfox,  amfexplorer, JSONovich, ExecuteJS, Restartless
XPI=(1843 748 2464 59 13793 5791 78928 10122 1729 249342)


echo "Getting Useful extensions ... "
for xpi in "${XPI[@]}"
do
    if [[ ! -f  addon-${xpi}-latest.xpi ]]
    then
    	wget https://addons.mozilla.org/firefox/downloads/latest/${xpi}/addon-${xpi}-latest.xpi
    fi
done

echo "Launching FF to install extensions and to do work ... "
nohup $FIREFOX -P $FPNAME  *.xpi &
sleep 1 
echo "-------------------- $(date) ------------------"
echo "-------------------- DISCONNECT ------------------"
