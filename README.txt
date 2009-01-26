Everything is Struct oriented. You can flip fluidly between treating things as
flat records (arrays) or as lightweight objects.

Objects come down the pipe as

  klass_name-key_field_1-key_field_2	attr_a	attr_b	attr_c

So user 123's record might look like

  twitter_user-0000000123	20090123012345	0000000123	abc	Baby look a me

while an AFollowsB record relating user 69 to user 123 serializes as

  a_follows_b-0000000069-0000000123	0000000069	0000000123

The efficiency vs. straightforwardness of repeating that many fields is still up
for debate. Works for now.


Twitter specific classes:


****************************************************************************
Scraper
  ++ 	scrape_request:
	  context		priority	id	page	screen_name
  =>	fetches file
****************************************************************************
Bundler
  ++	listing of scraped files,
  ++	scraped files
  => 	emit file metadata in order;
	cat files in order
	-> paste
	   context	scrape_date	priority	id	page	screen_name	size	scraped_at

****************************************************************************
Parser
  ++	bundled files
  => 	raw parsed data


- PARSE_JSON
  twitter_user_partial:	user_id		scraped_at	screen_name	protected	followers_count	
  		       	  		  		name		url		location	description
	       	  					image_url 
  twitter_user	      :	user_id		scraped_at	screen_name	protected	followers_count	friends_count	faves_count	statuses_count	created_at	
  twitter_user_profile:	user_id		scraped_at	name		url		location	description	time_zone	utc_offset
  twitter_user_style  :	user_id		scraped_at	bg_color	text_color	link_color	sb_border_color	sb_fill_color	bg_tile		bg_image_url	image_url
  a_follows_b	      :	a_id-b_id	scraped_at
  tweet		      :	tweet_id	created_at	user_id		text		favorited	truncated	tweet_len	inre_user_id	inre_status_id	fromsource	fromsource_url

- PARSE_TWEETS		tweet, user_ids
  a_atsigns_b		a_id		b_id		status_id	inre_status_id	is_retweet
  hashtag		user_id		hashtag		status_id
  tweet_url		user_id		url		status_id

- USER_WORDS		
  user_tweet_word	user_id		word		count		freq_user	freq_corpus	bnc_head	bnc_written_freq
  tweet_word		word		count		freq_corpus
  bnc_headwords		word				freq_corpus	freq_written	freq_spoken	range		dispersion	pos_list
  bnc_lemmas		word		headword	freq_corpus	freq_written	freq_spoken	range		dispersion	pos_list

- LIST_SCRAPED_FILES
  scraped_file		scraped_at	context 	user_id		page		screen_name	size		scrape_session
  
- PLAN_SCRAPE		< twitter_user_*, scraped_files 
  scrape_status		user_id		screen_name	protected	followers_count	friends_count	created_at	u_scraped_at	tup_scraped_at	foll_scraped_at	fr_scraped_at
  scrape_request	user_id		context		priority	page		screen_name	

- EXPAND_URLS
  expanded_urls		short_url	dest_url

- 
