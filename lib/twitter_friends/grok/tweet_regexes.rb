module TwitterFriends
  module Grok
    module TweetRegexes
      # ===========================================================================
      #
      # Twitter accepts URLs somewhat idiosyncratically, probably for good reason --
      # we rarely see ()![] in urls; more likely in a status they are punctuation.
      #
      # This is what I've reverse engineered.
      #
      #
      # Notes:
      #
      # * is.gd uses a trailing '-' (to indicate 'preview mode'): clever.
      # * pastoid.com uses a trailing '+', and idek.net a trailing ~ for no reason. annoying.
      #
      # Counterexamples:
      # * http://www.5irecipe.cn/recipe_content/2307/'/
      # * http://www.facebook.com/groups.php?id=1347199977&gv=12#/group.php?gid=18183539495
      #
      RE_DOMAIN_HEAD       = '(?:[a-zA-Z0-9\-]+\.)+'
      RE_DOMAIN_TLD        = '(?:com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum|[a-zA-Z]{2})'
      # RE_URL_SCHEME      = '[a-zA-Z][a-zA-Z0-9\-\+\.]+'
      RE_URL_SCHEME_STRICT = '[a-zA-Z]{3,6}'
      RE_URL_UNRESERVED    = 'a-zA-Z0-9'   + '\-\._~'
      RE_URL_OKCHARS       = RE_URL_UNRESERVED + '\'\+\,\;=' + '/%:@'   # not !$&()* [] \|
      RE_URL_QUERYCHARS    = RE_URL_OKCHARS    + '&='
      RE_URL_HOSTPART      = "#{RE_URL_SCHEME_STRICT}://#{RE_DOMAIN_HEAD}#{RE_DOMAIN_TLD}"
      RE_URL               = %r{(
                #{RE_URL_HOSTPART}                   # Host
     (?:(?: \/ [#{RE_URL_OKCHARS}]+?          )*?    # path:  / delimited path segments
        (?: \/ [#{RE_URL_OKCHARS}]*[\w\-\+\~] )      #        where the last one ends in a non-punctuation.
       |                                             #        ... or no path segment
                                              )\/?   #        with an optional trailing slash
        (?: \? [#{RE_URL_QUERYCHARS}]+  )?           # query: introduced by a ?, with &foo= delimited segments
        (?: \# [#{RE_URL_OKCHARS}]+     )?           # frag:  introduced by a #
      )}x


      #
      # Technically a scheme can allow the characters '+', '-' and '.' within
      # it. In practice you can not only ignore those characters but all but a
      # few specific schemes.
      #
      # From a collection of ~9M tweeted urls, 99.4% were http://, with only the additional
      #   https, mms, ftp, git, irc, feed, itpc, rtsp, hxxp, gopher, telnet, itms, ssh, webcal, svn
      # seemingly worth finding:
      #
      #   8925742 http
      #      6026 https  1841 ivo  122 mms    85 ftp    61 git  53 irc   45 feed   31 itpc  12 www
      #        12 rtsp     12 hxxp  12 gopher  9 telnet  9 itms  7 ssh    5 webcal  5 sop    4 wiie
      #         3 svn       3 sssp   3 file    2 res     1 xttp  1 xmlrpc 1 ssl     1 smb
      #
      # An hxxp http://en.wikipedia.org/wiki/Hxxp is used to obscure a link, so
      # take of that what you may.
      #
      # The ivo:// scheme is used by virtual astronomical observatories; as its
      # hostnames are given in reverse-dotted notation (uk.org.estar) these URIs
      # are imperfectly recognized.  Twitter doesn't accept them at all:
      #   http://twitter.com/eSTAR_Project/status/1113930948
      #
      #


      # ===========================================================================
      #
      # A hash following a non-alphanum_ (or at the start of the line
      # followed by (any number of alpha, num, -_.+:=) and ending in an alphanum_
      #
      # This is overly generous to those dorky triple tags (geo:lat=69.3), but we'll soldier on somehow.
      #
      RE_HASHTAGS        = %r{(?:^|\W)\#([a-zA-Z0-9\-_\.+:=]+\w)(?:\W|$)}

      # ===========================================================================
      #
      # Retweets and Retweet Whores
      #
      # See ARetweetsB for more info.
      #
      # A retweet
      #   RT @interesting_user Something so witty Dorothy Parker would just give up
      #   Oh yeah and so's your mom (via @sixth_grader)
      #   retweeting @ogre: KEGGER TONITE RT pls
      #     ^^^ this is not a rtwhore; it matches first as a retweet
      #
      # and rtwhores
      #   retweet please: Hey here's something I'm whoring xxx
      #   KEGGER TONITE RT pls
      #
      # or semantically-incorrect matches such as (actual example):
      #    @somebody lol, love the 'please retweet' ending!
      #
      # Things that don't match:
      #   retweet is silly, @i_think_youre_dumb
      #    misspell the name of my Sony Via
      #
      RE_RETWEET_WORDS  = 'rt|retweet|retweeting'
      RE_RETWEET_ONLY   = %r{(?:#{RE_RETWEET_WORDS})}
      RE_RETWEET_OR_VIA = %r{(?:#{RE_RETWEET_WORDS}|via|from)}
      RE_PLEASE         = %r{(?:please|plz|pls)}
      RE_RETWEET        = %r{\b#{RE_RETWEET_OR_VIA}\W*@(\w+)\b}i
      RE_RTWHORE        = %r{
          \b#{RE_RETWEET_ONLY}\W*#{RE_PLEASE}\b
        | \b#{RE_PLEASE}\W*#{RE_RETWEET_ONLY}\b}ix

      # ===========================================================================
      #
      # following either the start of the line, or a non-alphanum_ character
      # the string of following [a-zA-Z0-9_]
      #
      # Note carefully: we _demand_ a preceding character (or start of line):
      # \b would match email@address.com, which we don't want.
      #
      # Making an exception for RT@im_cramped_for_space.
      #
      # All retweets
      #
      RE_ATSIGNS         = %r{(?:^|\W|#{RE_RETWEET_OR_VIA})@(\w+)\b}
    end
  end
end
