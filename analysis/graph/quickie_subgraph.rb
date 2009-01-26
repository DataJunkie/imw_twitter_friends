#!/usr/bin/env ruby
require 'set'

FOLLOWERS = %w[
        2zen2 360acl abesselink achmorrison aduthie AK1TLX5RRG akraut alkalineearth
        antondrive AriT93 arkanjil austin360 band BaseCase BlueDragon313
        brokenkeyboard bunni3burn calatwit campbelltron cheaptweet chfbrian chux0r cspan
        datamapper ddavis216 dfjkl dfu dhuyler Dina451 dirtrid3r doncarlo Dr0id
        dreamkote Drxu elogan elzr EmilyE19 etdragon EveSimon fbase FuseTV GenGreen geni
        gilliss habcous hayesdavis hjudaddio HollyIngram ihatemyjobtv
        infochimps itcouldbepic jarrodtrainque jmay JonTheGeek kromer KXAN_News
        lfeeney lucasjosh mathlete79 MattSpringer medooooo misswinnie mrflip mrflip91
        mrflippy mrichman ms_c mwh02 nurelle OWD PelleB pjiutzi plaidteam
        PrincessBooBoo RaijinQ RoundSparrow sandieman senjutsu Silona sinned Skud
        slignot splatnik sterno stilist SuzInDC techknow TheOtherJeff
        thesauceisboss ThommyB Thrack tibbon transformer68 trueknowledge turkchgo
        vizsage whurley worksintheory zieglerfe
        Oozzl zefrank yobird hashtags kvetch Situn springnet sxsw  BigOrganicNetwk
].to_set

#

FOLLOWING = %w[
        2zen2 aaronsw abesselink achmorrison aduthie akraut alkalineearth AriT93 band
        BaseCase BillCorbett BlueDragon313 bunni3burn campbelltron catbird
        change_congress chux0r cocoajunkie datamapper ddavis216 dfjkl dfu dhuyler
        doncarlo dorabianchi Dr0id dreamkote Dynagrip Ehrensenf elogan elzr EmilyE19
        etdragon everyblock everymomentnow EveSimon fayewhitaker fbase fireland
        fivethirtyeight flowingdata gbailey gilliss habcous hanneloreEC
        hayesdavis HenryPaulson HollyIngram infochimps itcouldbepic jarrodtrainque
        jkottke jmay JonTheGeek joshdsullivan jwz jzawodn kvetch lfeeney linearb
        lucasjosh markphillip martenreed mathlete79 mathowie matthewbaldwin
        MattSpringer medooooo misswinnie mrflip mrflippy mrichman ms_c mwh02 nurelle
        NYTimesKristof PelleB penelopegaines pintsize0101 pjiutzi pmog PrincessBooBoo
        RaijinQ RoundSparrow sandieman senjutsu Silona sinned Skud slignot splatnik
        startupdistrict sterno stilist strawpoll SuzInDC svenbianchi sxswlive
        techknow TheOtherJeff thesauceisboss Thrack trueknowledge turkchgo uhacc vizsage
        waxpancake whurley _why worksintheory zieglerfe
        zefrank MarsPhoenix hashtags springnet sxsw
].to_set
#

EITHER = FOLLOWING + FOLLOWERS

$stdin.each do |line|
  rel, item_key, user_a_id, user_b_id, user_a_name, user_b_name, scraped_at = line.chomp.split("\t")
  next unless scraped_at
  if EITHER.include?(user_a_name) && EITHER.include?(user_b_name)
    puts [ rel, user_a_id, user_b_id, user_a_name, user_b_name ].join("\t")
  end
end


