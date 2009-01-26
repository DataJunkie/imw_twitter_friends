#!/usr/bin/env bash
poolpath="social/network/twitter_friends/public_timeline"
datadir="/data/rawd/${poolpath}"
logdir="/data/log/${poolpath}"

public_url=`ruby -e 'require "twitter_pass"; puts TWITTER_DATAMINING_FEED_URL'`
trends_url="http://search.twitter.com/trends.json"
waittime=58

mkdir -p $logdir
mkdir -p $datadir
cd       $datadir
for (( i=0 ; 1 ; true )) ; do
    logname=$logdir/`date +'twitter_public_timeline-%Y%m%d.log'`
    mkdir -p `dirname $logname`
    datedir=$datadir/`date +'%Y%m/%d/%H'`
    mkdir -p $datedir
    datetime=`date +'%Y%m%d-%H%M%S'`
    wget -nc -nv -a $logname $public_url -O $datedir/public_timeline-$datetime.json
    # wget -nc -nv -a $logname $trends_url -O $datedir/trends-$datetime.json
    sleep $waittime
    true
done

 
