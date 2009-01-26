ls -l arch/ripd/*/* | cut -c 23-32,50- > /tmp/ls_local
hdp-ls arch/ripd/\*   | cut -c 33-42,71- >/tmp/ls_hdfs
diff -uw /tmp/ls_*
