#!/usr/bin/env bash

all_src_files=fixd/favorites,fixd/followers,fixd/friends,fixd/user_timeline,fixd/user,fixd/public_timeline

./queries/bundle.sh  user favorites followers friends user_timeline

for rsrc in user favorites followers friends user_timeline public_timeline ; do
  dest=fixd/$rsrc
  hdp-rm -r $dest ; ./parse_json.rb         --go rawd/bundled/$rsrc $dest
done

dest=fixd/text_elements
hdp-rm -r $dest ; ./grokify.rb              --go $all_src_files 		   $dest

dest=fixd/all
hdp-rm -r $dest ; ./queries/uniq_by_last.rb --go $all_src_files,fixd/text_elements $dest

dest=fixd/flattened
hdp-rm -r $dest ; ./queries/flatten_keys.rb --go fixd/all 			   $dest
./lib/hadoop/bin/hdp-parts_to_keys.rb $dest

dest=fixd/rdfified
hdp-rm -r $dest ; ./rdfify.rb  		    --go fixd/all 	 		   $dest

#
# package
#
listing=tmp/fixd-all-package-listing  ;
pkgd_log=tmp/fixd-all-package-log ;
hdp-rm $listing ;
hadoop dfs -lsr fixd | egrep '(part-|.tsv)' | hdp-put - $listing ;

hdp-rm -r $pkgd_log ;
./package.rb --go --map_tasks=1 $listing $pkgd_log

dumpdir=~/ics/pool/social/network/twitter_friends/pkgd/pkgd-`datename`
mkdir -p $dumpdir
hdp-get pkgd/user/flip/fixd  $dumpdir

rsync -Cuvzrltp $dumpdir/ $MRFLIP:~/ics/pool/social/network/twitter_friends/pkgd/pkgd-`datename`/
