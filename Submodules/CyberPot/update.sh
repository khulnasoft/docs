#!/bin/bash

# Some global vars
myCOMPOSEFILE="~/cyberpot/docker-compose.yml"
myDATE=$(date +%Y%m%d%H%M)
myRED="[0;31m"
myGREEN="[0;32m"
myWHITE="[0;0m"
myBLUE="[0;34m"

myUPDATER=$(cat << "EOF"
   ______      __              ____        __ 
  / ____/_  __/ /_  ___  _____/ __ \____  / /_
 / /   / / / / __ \/ _ \/ ___/ /_/ / __ \/ __/
/ /___/ /_/ / /_/ /  __/ /  / ____/ /_/ / /_  
\____/\__, /_.___/\___/_/  /_/    \____/\__/  
     /____/                 
EOF
)

# Check if running with root privileges
if [ ${EUID} -eq 0 ];
  then
    echo "This script should not be run as root. Please run it as a regular user."
    echo
    exit 1
fi

# Let's test the internet connection
function fuCHECKINET () {
	mySITES=$1
	  echo
	  echo "### Now checking availability of ..."
	  for i in $mySITES;
	    do
	      echo -n "###### $myBLUE$i$myWHITE "
	      curl --connect-timeout 5 -IsS $i >/dev/null 2>&1
	        if [ $? -ne 0 ];
	          then
		    echo
	            echo "###### $myBLUE""Error - Internet connection test failed.""$myWHITE"" [ $myRED""NOT OK""$myWHITE ]"
	            echo "Exiting.""$myWHITE"
	            echo
	            exit 1
	          else
	            echo "[ $myGREEN"OK"$myWHITE ]"
	        fi
	  done;
	echo
}

# Update
function fuSELFUPDATE () {
	echo
	echo "### Now checking for newer files in repository ..."
	git fetch --all
	myREMOTESTAT=$(git status | grep -c "up-to-date")
	if [ "$myREMOTESTAT" != "0" ];
	  then
	    echo "###### $myBLUE""No updates found in repository.""$myWHITE"
	    return
	fi
	### DEV
	myRESULT=$(git diff --name-only origin/master | grep "^update.sh")
	if [ "$myRESULT" == "update.sh" ];
	  then
	    echo "###### $myBLUE""Found newer version, will be pulling updates and restart myself.""$myWHITE"
	    git reset --hard
	    git pull --force
	    exec ./update.sh -y
	    exit 1
	  else
	    echo "###### $myBLUE""Pulling updates from repository.""$myWHITE"
	    git reset --hard
	    git pull --force
	fi
	echo
}

function fuCHECK_VERSION () {
	local myMINVERSION="24.04.0"
	local myMASTERVERSION="24.04.0"
	echo
	echo "### Checking for version tag ..."
	if [ -f "version" ];
	  then
	    myVERSION=$(cat version)
	    if [[ "$myVERSION" > "$myMINVERSION" || "$myVERSION" == "$myMINVERSION" ]] && [[ "$myVERSION" < "$myMASTERVERSION" || "$myVERSION" == "$myMASTERVERSION" ]]
	      then
	        echo "###### $myBLUE$myVERSION is eligible for the update procedure.$myWHITE"" [ $myGREEN""OK""$myWHITE ]"
	      else
	        echo "###### $myBLUE $myVERSION cannot be upgraded automatically. Please run a fresh install.$myWHITE"" [ $myRED""NOT OK""$myWHITE ]"
		exit
	    fi
	  else
	    echo "###### $myBLUE""Unable to determine version. Please run 'update.sh' from within 'cyberpot/'.""$myWHITE"" [ $myRED""NOT OK""$myWHITE ]"
	    exit
	  fi
	echo
}

# Stop CyberPot to avoid race conditions with running containers with regard to the current CyberPot config
function fuSTOP_CYBERPOT () {
	echo
	echo "### Need to stop CyberPot ..."
	echo -n "###### $myBLUE Now stopping CyberPot.$myWHITE "
	sudo systemctl stop cyberpot.service
	if [ $? -ne 0 ];
	  then
	    echo " [ $myRED""NOT OK""$myWHITE ]"
	    echo "###### $myBLUE""Could not stop CyberPot.""$myWHITE"" [ $myRED""NOT OK""$myWHITE ]"
	    echo "Exiting.""$myWHITE"
	    echo
	    exit 1
	  else
	    echo "[ $myGREEN"OK"$myWHITE ]"
	    echo -n "###### $myBLUE Now cleaning up containers.$myWHITE "
	    if [ "$(docker ps -aq)" != "" ];
	      then
	        docker stop $(docker ps -aq)
	        docker container prune -f && docker image prune -f && docker volume prune -f
	    fi
	    echo "[ $myGREEN"OK"$myWHITE ]"
	fi
	echo
}

# Backup
function fuBACKUP () {
	myARCHIVE="$HOME/${myDATE}_cyberpot_backup.tgz"
	local myPATH=$PWD
	echo
	echo "### Create a backup, just in case ... "
	echo -n "###### $myBLUE Building archive in $myARCHIVE $myWHITE"
	cd $HOME/cyberpot
	sudo tar cvf $myARCHIVE * .env >/dev/null 2>&1
	sudo chown $LOGNAME:$LOGNAME $myARCHIVE
	if [ $? -ne 0 ];
	  then
	    echo " [ $myRED""NOT OK""$myWHITE ]"
	    echo "###### $myBLUE""Something went wrong.""$myWHITE"" [ $myRED""NOT OK""$myWHITE ]"
	    echo "Exiting.""$myWHITE"
	    echo
	    cd $myPATH
	    exit 1
	  else
	    echo "[ $myGREEN"OK"$myWHITE ]"
	    cd $myPATH
	fi
	echo
}

# Remove old images for specific tag
function fuREMOVEOLDIMAGES () {
	local myOLDTAG=$1
    echo "### Removing old docker images."
    docker rmi $(docker images -q "$myOLDTAG") >/dev/null 2>&1
}

function fuPULLIMAGES {
	docker compose -f ~/cyberpot/docker-compose.yml pull
}

function fuUPDATER () {
	echo "### Now pulling latest docker images ..."
	echo "######$myBLUE This might take a while, please be patient!$myWHITE"
	fuPULLIMAGES
	fuREMOVEOLDIMAGES "khulnasoft/*:dev"
	fuREMOVEOLDIMAGES "ghcr.io/khulnasoft/*:dev"
	echo
	echo "### If you made changes to docker-compose.yml please ensure to add them again."
	echo "### We stored the previous version as backup in $myARCHIVE."
	echo "### Some updates may need an import of the latest Kibana objects as well."
	echo "### Download the latest objects here if they recently changed:"
	echo "### https://raw.githubusercontent.com/khulnasoft/cyberpot/master/etc/objects/kibana_export.ndjson.zip"
	echo "### Export and import the objects easily through the Kibana WebUI:"
	echo "### Go to Kibana > Management > Saved Objects > Export / Import"
	echo
}

function fuRESTORE () {
	if [ -f '~/cyberpot/data/ews/conf/ews.cfg' ] && ! grep 'ews.cfg' $myCOMPOSEFILE > /dev/null; then
	    echo
	    echo "### Restoring volume mount for ews.cfg in cyberpot.yml"
	    sed -i '/- ${CYBERPOT_DATA_PATH}:\/data/a \ \ \ \ \ - ${CYBERPOT_DATA_PATH}/ews/conf/ews.cfg:/opt/ewsposter/ews.cfg' $myCOMPOSEFILE
	fi
	echo "### Restoring CyberPot config file .env"
	tar xvf $myARCHIVE .env -C $HOME/cyberpot >/dev/null 2>&1
}

################
# Main section #
################

# Only run with command switch
sudo echo "$myUPDATER"

if [ "$1" != "-y" ]; then
  echo
  echo "This script will update CyberPot to the latest version."
  echo "A backup of ~/cyberpot will be written to $HOME. If you are unsure, you should save your work."
  echo "This tool might break things and therefore only recommended for experienced users."
  echo "If you understand the involved risks feel free to run this script with the '-y' switch."
  echo
  exit
fi

fuCHECK_VERSION
fuCHECKINET "https://index.docker.io https://github.com"
fuSTOP_CYBERPOT
fuBACKUP
fuSELFUPDATE "$0" "$@"
fuUPDATER
fuRESTORE

echo
echo "### Done. You can now start CyberPot using 'systemctl start cyberpot' or 'docker compose up -d'."
echo