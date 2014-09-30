#!/bin/bash                                                                                                                                    

if [ $# -ne 2 ];
then
   echo "usage: ./yo_pid.sh pid yo_name"
   exit
fi

prev_time="0"
curr_time=$(ps -p $1 -o time | sed -n 2p)


while [ $curr_time != $prev_time ]
do
    sleep 30
    a=$curr_time
    curr_time=$(ps -p $1 -o time | sed -n 2p)
    prev_time=$a
done

curl --data "api_token={{api key}}&username=$2" http://api.justyo.co/yo/