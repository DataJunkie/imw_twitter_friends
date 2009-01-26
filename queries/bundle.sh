#!/usr/bin/env bash

#resources="$@"
noid_resources='followers friends favorites'
id_resources="user user_timeline"
resources="$noid_resources $id_resources public_timeline"
script_dir=`dirname $0`

# File listing all user ids
user_ids_file=rawd/user_ids/user_ids_all.tsv
# Directory for lists of .tar packages to bundles
scrape_store_listing_dir=tmp/scrape_store_listings

#
# List files
#
for resource in $resources ; do
    listing=${scrape_store_listing_dir}/scrape_store_listings-$resource.tsv
    hdp-rm $listing
    # | grep -v 'supergroup  [ 1-9][0-9]' 
    hdp-ls "arch/ripd/*/*${resource}*" | hdp-put - $listing 
done
resource=public_timeline
listing=${scrape_store_listing_dir}/scrape_store_listings-$resource.tsv
hdp-rm $listing
hdp-ls "arch/public_timeline/*${resource}*" | hdp-put - $listing 

for resource in $noid_resources ; do
    echo "Bundling $resource"
    listing=${scrape_store_listing_dir}/scrape_store_listings-$resource.tsv 
    bundled=tmp/bundled_noid/${resource}
    hdp-rm -r $bundled
    $script_dir/bundle.rb --go --nopartition --sort_keys=2 ${listing} ${bundled}
done
for resource in $noid_resources ; do
    bundled_noid=tmp/bundled_noid/${resource}
    bundled=rawd/bundled/${resource}
    hdp-rm -r $bundled
    $script_dir/bundle_insert_ids.rb --go --nopartition ${bundled_noid},${user_ids_file} ${bundled}
done
for resource in $id_resources public_timeline ; do
    echo "Bundling $resource"
    listing=${scrape_store_listing_dir}/scrape_store_listings-$resource.tsv 
    bundled=rawd/bundled/${resource}
    hdp-rm -r $bundled
    $script_dir/bundle.rb --go --nopartition --sort_keys=2 ${listing} ${bundled}
done
