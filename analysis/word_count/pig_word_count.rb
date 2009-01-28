#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'wukong'                       ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'wukong/and_pig'               ; include Wukong::AndPig

PIG_DEFS_DIR = File.dirname(__FILE__)+'/..'

class WordToken < TypedStruct.new [
    [:rsrc,      String,  ],
    [:context,   String,  ],
    [:user_id,   Integer, ],
    [:token,     String,  ],
    [:usages,    Integer  ],
    ]
  include PigEmitter
end

class ScalarInteger  < TypedStruct.new [
    [:count,    Integer  ],
  ]
  include PigEmitter
  def self.load_scalar path
    var = super path
    var.to_i
  end
end

# ===========================================================================
#
# Initialize
#
WORK_DIR = 'meta/datanerds/token_count'
PigVar.default_path = WORK_DIR
Wukong::AndPig.init_load

#
# Load the tokens from our ruby script
#
users_tokens         = WordToken[:users_tokens].load

#
# Count the total number of users who said anything
# users_count     = users_tokens.count_distinct(:users_count, :user_id, :by => :all).store!
users_count     = ScalarInteger.load_scalar :users_count

#
# And the total number of tokens they said
# tokens_count    = users_tokens.count_distinct(:tokens_count, :token, :by => :all).store!
tokens_count     = ScalarInteger.load_scalar :tokens_count

#
#
# #
# # Get the per-user statistics
# #
# user_token_stats = users_tokens.
#   group(:user_token_stats_1, :by => :user_id, :parallel => 25).
#   foreach(:user_token_stats_2, %Q{  {
#     tot_tokens    = (int)COUNT(#{users_tokens.relation}) ;
#     tot_usages    = (int)SUM(  #{users_tokens.relation}.usages ) ;
#     GENERATE group AS user_id,
#            tot_tokens AS tot_tokens,
#            tot_usages AS tot_usages,
#            FLATTEN(#{users_tokens.relation}.(token, usages) ) AS (token, usages);
#     }
#   }).foreach(:user_token_stats_3, %Q{  {
#     usage_pct     = (float)(1.0*usages / tot_usages) ;
#     usage_pct_sq  = (float)(1.0*usages / tot_usages) * (1.0*(float)usages / tot_usages) ;
#     GENERATE user_id, token, usages,
#            usage_pct      AS usage_pct,
#            usage_pct_sq   AS usage_pct_sq ;
#     }
#   }).illustrate
#
# # # rmf meta/datanerds/token_count/user_toks_flat ;
# # # STORE UserToksFlat INTO 'meta/datanerds/token_count/user_toks_flat' ;
# # # UserToksFlat     = LOAD 'meta/datanerds/token_count/user_toks_flat' AS
# # #       (user_id: int,token: chararray,usages: int,usage_pct: float, usage_pct_sq: float) ;



# ===========================================================================
#
# Statistics for each token
#
# Note that the line   tot_users = (int)COUNT(UserToksFlat) ;
# is correct: we're counting the *alias*, one per each user.
#
# Range is how many people used the token
#
# Dispersion is Julliand's D
#
#               V
# D = 1 - ---------------
#           sqrt(n - 1)
#
# V = s / x
#
# Where
#
# * n is the number of users
# * s is the standard deviation of the subusagesuencies
# * x is the average of the subusagesuencies
#
#  /public/share/pig/contrib/piggybank/java/src/main/java/org/apache/pig/piggybank/evaluation/math/SQRT.java

# puts %Q{
#
#     TokenStats_1    = GROUP UserToksFlat BY token ;
#     TokenStats      = FOREACH TokenStats_1 {
#       range         = (int)COUNT(UserToksFlat) ;
#       pct_range     = (int)COUNT(UserToksFlat)      / 436.0;
#       tot_usages    = (int)SUM(UserToksFlat.usages) ;
#       ppm_usages    = (int)( 1e6 * SUM(UserToksFlat.usages) / 61630 );
#       avg_uspct     = (float)SUM(UserToksFlat.usage_pct)    /  436.0 ;
#       sum_uspct_sq  = (float)SUM(UserToksFlat.usage_pct_sq);
#       stdev_uspct   = org.apache.pig.piggybank.evaluation.math.SQRT(
#                             (sum_uspct_sq /436) -
#                             ( (SUM(UserToksFlat.usage_pct)/436.0) * (SUM(UserToksFlat.usage_pct)/436.0) )
#                             );
#       dispersion    = 1 - ( ( stdev_uspct / avg_uspct ) / org.apache.pig.piggybank.evaluation.math.SQRT(436.0 - 1.0) );
#       GENERATE group        AS token,
#                range        AS range,
#                pct_range    AS pct_range,
#                tot_usages   AS tot_usages,
#                ppm_usages   AS ppm_usages,
#                avg_uspct    AS avg_uspct,
#                stdev_uspct  AS stdev_uspct,
#                dispersion   AS dispersion;
#     }
#     STORE TokenStats INTO 'meta/datanerds/token_count/token_stats' ;
#     TokenStats     = LOAD 'meta/datanerds/token_count/token_stats' AS
#                           (token: chararray,range: int, pct_range: double, tot_usages: int,
#                            ppm_usages: int,avg_uspct: double,stdev_uspct: double,dispersion: double) ;
# }


