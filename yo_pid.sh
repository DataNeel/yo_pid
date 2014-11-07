#!/bin/bash                                                                                                                      

while getopts ":c:u:p:" opt; do
  case $opt in
    c) COMMAND="$OPTARG";;
    u) YONAME=$OPTARG;;
    p) PID=$OPTARG;;
    :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    \?) echo "Invalid option: -$OPTARG" >&2;
	echo "Use -c to provide a command or -p to provide a PID";
	echo "Use of -u to specify a Yo name is required";
	exit 1;;
  esac
done

if ([ -z "$COMMAND" ] && [ -z $PID ]) || [ -z $YONAME ]
then
    echo "Not enough options provided"
    echo "Use -c to provide a command or -p to provide a PID"
    echo "Use of -u to specify a Yo name is required"
    exit 1
fi

if [ ! -z "$COMMAND" ] && [ ! -z $PID ]
then
    echo "Command and PID both provided"
    echo "Provide only a command using -c or a PID using -p"
    exit 1
fi

happy=(http://i.imgur.com/ntJKbx2b.jpg http://i.imgur.com/1rvPf.gif http://i.imgur.com/aWlRv.gif http://i.imgur.com/s88jNqX.gif)
sad=(http://i.imgur.com/hdW2w.gif http://i.imgur.com/RuYH0.gif http://i.imgur.com/zS5rRxa.gif http://i.imgur.com/uvz4Qys.gif http://i.imgur.com/JZ7yXUM.gif http://i.imgur.com/ldtpOON.gif http://i.imgur.com/fkLF9.gif)
random_gif=""

if [ ! -z "$COMMAND" ]
then 
    eval "$COMMAND"
    EXIT_STATUS=$?
    if [[ $EXIT_STATUS == 0 ]]; then
        rando=$[ 1 + $[ RANDOM % ${#happy[@]}]]
        random_gif="&link=${happy[rando-1]}"
    else
        rando=$[ 1 + $[ RANDOM % ${#sad[@]}]]
        random_gif="&link=${sad[rando-1]}"
    fi
fi

if [ ! -z $PID ]
then
      prev_time="0"
      curr_time="$(ps -p $PID -o time,pmem,sgi_p | sed -n 2p)"
      while [ "$curr_time" != "$prev_time" ]
      do
	  sleep 30
	  a="$curr_time"
	  curr_time="$(ps -p $PID -o time,pmem,sgi_p | sed -n 2p)"
	  prev_time="$a"
      done
fi

curl --data "api_token={{api key}}&username=${YONAME}${random_gif}" http://api.justyo.co/yo/
