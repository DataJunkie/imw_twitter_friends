
# ===========================================================================
#
# tests = [
#   'http://foo.us/',
#   'http://foo.us/a',
#   'http://foo.us/a?q=a',
#   'http://foo.us/a#a',
#   'http://foo.us/a?q=a&b=3#a',
#   'http://foo.us/a;2/~m-_.\':%+@,;?q=a&b=3#a',
#   'http://foo.us/a?q=a?',
#   'http://foo.us/=a#a',
#   'http://foo.us/a&?q=a&b=3#a',
#   'http://foo.us/a;2/~m-_.\':%+@,;?q=a&b=3#a&',
# ]
# tests.each do |test_str|
#   p test_str.scan(RE_URL)
# end
#
# atsign_tests = [
#   '@foo hello',
#   ' @foo @hello  ',
#   ' @foo, @hello  ',
#   '-@foo,@hello',
#   '@foo@bar ',
#   'a  basdf@foo b',
#   'http://@foo',
#   'foo@bar @bar@foo @zz+',
# ].each do |test_str|
#   p test_str.scan(RE_ATSIGNS)
# end
#
# hash_tag_tests = [
#   '#downtown',
#   '#downtown?',
#   '#downtown.',
#   '#downtown]',
#   '#downtown}',
#   '#downtown)',
#   '#downtown,',
#   '#downtown;',
#   '#downtown\'',
#   '#downtown\'s',
#   '#downtown_',
#   '#down+town',
#   '#down_town',
#   '#down-town',
#   '#www.downtown.com',
#   '#www.downtown.com.',
#   '##',
#   '#.',
#   '#taxonomy:binomial=Alcedo_atthis',
#   '#geo:lat=52.478342',
#   '#geo:lon=53.609130',
#   'a#www.downtown.com.',
#   ' #www.downtown.com.',
#   ' =#www.downtown.com.!',
# ].each do |test_str|
#   p test_str.scan(RE_HASHTAGS)
# end
#
#
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown
# # #downtown_
# # #down+town
# # #down_town
# # #down-town
# # #www.downtown.com
# # #www.downtown.com
# #
# #
# # #taxonomy:binomial=Alcedo_atthis
# # #geo:lat=52.478342
# # #geo:lon=53.609130
