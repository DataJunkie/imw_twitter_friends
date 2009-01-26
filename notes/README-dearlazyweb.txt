
* 2-hood

* all-pairs shortest distance
  3e6 users => 9e12 naive distances.
  so, this would have to be smart.  There's a "highway" structure.
  - first, though: what is a "connection"? You want something reinforced: symmetric, symmetric @replies (but just those two would trigger on an @zappos), high 2-hood impact <-- best.
  - do it on symm links so it can be all DM's.

* Geolocate all users.  I've pulled off the low-hanging fruit: the top identifiable terms and the iPhone/etc. lat+lng coordinates.  You also have time zone.  Location can change over time
  - how, over a few samples, do you get the 'typical' location of a user? probably the mode (most-commonly-occurring).  Certainly the average doesn't make sense.

* Isolate topic clusters by doing LSA on the twitter stream -- 
   around statistically improbable phrases in each user's tweetstream.  Users who discuss 'purl', 'pearl', 'perl' and 'burl' each have different hobbies.


* There are at least five different networks of users in this dataset:
  - the explicit follower-friend directed network graph
  - the @atsign directed graph
  - geographic clusters
  - hashtag clusters
  - topic clusters
  - [also, tweet_url's -- but this is probably of such low quality as to be useless. Prove me wrong.]

  Visualizing any one of these networks is challenging.  Find meaningful ways to visualize all five and how they interact and correspond.

* How does the network change when you weight the edges?
  - symmetric links
  - high 2-hood links
  - topical correspondence
  - @reply count

* Connect to larger world through Identity Claims




* Classifying users:
  
	1-i-hd	Symm	2-hood		@replies	topical diversity	link rate

  Gregarious Celebrity		Zefrank
	Massive, Symmetric, 2-sparse, responsive, eclectic
  Elite Celebrity		Kottke
	
  Elite  Celebrity Entity	Mars Phoenix
  Gregarious Celebrity Entity	BarackObama
 	Massive, Symmetric, 2-sparse, broadcasting, narrow, low std.dev of tweet rate
  Spam Bot
	high tweet_url rate
	followers lag friends -- that is, user B only follows X in response to X first following B.
	narrow topic spectrum
	(follow bot: 
  Antenna Entity		KXAN news, 
 	like a spam bot but broad
	either a narrow topic spectrum OR a narrow geographic spectrum of followers
  Announcer Entity		RUWTBot
	Many followers, friends either none or symmetric. 2-sparse. high tweet_url rate. diverse prestige spectrum of followers.
	... [prediction: announcers, whose purpose is to broadcast, don't follow back or do so reflexively.]

  Regular Joe -- small group of friends, follows some celebrities/entities, 
	moderate, symmetric, 2-dense, moderately responsive, eclectic, bursty
	links at same prestige largely reciprocated.
	links to higher prestige are not.

  Cul de Sac -- uses twitter for their small group of friends and that's it.
	almost completely 2-dense. @atsign and following networks the same. moderate link rate


  Recluse -- 			Lessig
	high follower rate
	low or nil tweet rate

  Quipster --
	low stdev of tweet rate (low burstiness)
 	few @atsigns 
  Actors' Circle		HanneloreEC

  TwitService			hashtags, kvetch




* Aesthetics

* Is this user's pic a face, a logo, or something else?