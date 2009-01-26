#!/usr/bin/env bash

echo "Scripts to copy and paste from.  Don't run me directly"
exit

#
# Copy all archives to the DFS
#

for seg in ripd public_timeline ; do
    cd ~/ics/pool/social/network/twitter_friends;
    hdp-ls "arch/$seg/*" > tmp/arch-${seg}-listing.txt;
    for tarfile in arch/{${seg},$seg/*}/*.bz2 ; do
	if  [ -e "$tarfile" -a -z "`grep $tarfile tmp/arch-$seg-listing.txt `" ] ; then
            echo "Copying $tarfile ";
            hdp-put $tarfile $tarfile ;
	fi ;
    done;
done



#
# Get a sampling of
#
dest=tmp/sample_tweets.tsv
rm $dest ;
for foo in  '#|[^"]http://|@'  '(RT|retweet|via).*@[A-Za-z0-9_]' \
    '(RT|retweet).*(please|plz|pls)' '(please|plz|pls).*RT|retweet)' ; do
    hdp-cat fixd/user/p\*0 | egrep "$foo" | head -n 200 >> $dest ;
done


#
# List all bad ids
#
hdp-catd tmp/user_ids/user_ids_all-20090111 | \
    cut -d'   ' -f2,3 | \
    ruby -ne '$_.chomp! ; id,sn,*_=$_.split(/\t/) ; puts $_ if ( (sn =~ /\W/)  || (!sn) || (sn.empty?) )' \
    > fixd/dump/bad_ids_`datename`.tsv
