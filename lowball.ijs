NB.* lowball.ijs: fns for ranking lowball poker hands.

bestLows=: 3 : 0"1
   holeCards=. a. i. >0{y
   plh=. (#holeCards)$a: [ lowEntry=. '';''  NB. Initialize as empty
NB. In the following section, we map card face values from 0-12 (2-A) to 1-13 (A-K) and
NB.  work only with face values, ignoring suits.
   if. 3<:#common=. onlyValidLowCards 1{suitRank a.i.>4{y do.
      holeCards=. onlyValidLowCards&.><"1 holeCards
      possHC=. 2<:#&>holeCards
      plh=. ~.&.>&.>(<common) allPoss &.> possHC#holeCards   NB. Possible low hands for each player
      whgt5=. 5<:&.>#&>&.>plh
      plh=. whgt5#&.>plh                     NB. Only 5-card or better possibilities
      if. 1 e. whp5ch=. 0<#&>plh do.         NB. Where possible 5-card hands
         plh=. \:~"1&.>>&.>plh               NB. Order face values descending for each possible hand
	 lowHands=. /:~&.>plh                NB. Order all possib hands from best (lowest) to worst
	 lowHands=. whp5ch#lowHands          NB. Will map player # back at end.
	 besties=. /:{.&>lowHands            NB. order by best hand first
	 bl=. {.&>lowHands                   NB. Best low per player
	 blWTies=. bl*./ . =bl{~{./:bl       NB. Which are winners, accounting for ties
	 whBest=. possHC#^:_1 whp5ch#^:_1 blWTies NB. Which players have best hand
NB. Save hand as face values only: 1: Ace, 2:2, 3:3, etc.
	 lowEntry=. (<a.){~&.>(I. whBest);<,~.blWTies#bl NB. Which player(s) won, best low hand, as char.
      end.
   end.
   lowEntry
)

onlyValidLowCards=: [: ([: ~. ] #~ 8 >: ]) [: >: 13 | >:  NB. Map face values to 1-13 = (A (low) - K)

lowerAce=: 3 : '((12=1{y)}(1{y),:_1) 1}y'   NB. card rank 12->_1 (ace->1)
raiseAce=: 3 : '((_1=1{y)}(1{y),:12) 1}y'   NB. card rank _1->12 (1->ace)

bestPossLow=: 3 : 0
   {./:~(] #~ 0 ~: [: #&> {."1) onlyBestLow &> y  NB. 1st lowest of ranks sorted descending.
)

onlyBestLow=: 3 : 0
   bl=. (] #~ 6 >: [: {. [: > 0 {  ]) bestLow y   NB. 8*./ . >: ranks
   (] #~&.> 5=[: # [: >{.) bl                     NB. 5 cards/hand
)

NB.* bestLow: return best low hand given some cards.
NB. California rules->straights and flushes do not count against low hand,
NB. so we ignore them here.
bestLow=: 3 : 0
   y=. (]/:1{"1]) &.|: lowerAce suitRank y
   y=. (]#"1~1,2~:/\1{]) y                   NB. Remove duplicate ranks
   y=. (5<.{:$y){."1 (]#"1~1,2~:/\1{]) y     NB. Pick lowest 5 if enough
   (([: (|.) 1 {  ]) ; suitRank@:raiseAce) y NB. Ranks, high to low; hand
)

bestLowRM=: 3 : 0        NB. Thanks to Raul Miller
  cards=. y\:13|y
  kinds=. 14|2+13|cards
  hands=. 5 comb #y      NB. Check all 5-card combinations [unnecessary]
  ranks=. 13 #. (,.~ [: >./"1 #/.~"1) hands{kinds
  (hands{~(i.<./)ranks){cards
)

bestLow0=: 3 : 0        NB. Thanks to Raul Miller
   cards=. y{~ord=. /:ranks=. 14|2+13|y
   unqs=. 1,2~:/\ranks{~ord
   if. 5<:+/unqs do. |.5{.unqs#cards  NB. Order low hand descending
   else. 5$50 end.                    NB.  or no 5-card low -> 5 Kings
)
   
lowOrdering=: ] \: 1 {  [: lowerAce suitRank NB. Show low hands in descending order of rank with ace low.

bestLowHands=: 13 : '([: {. [: /:~ [: (14|2+13|])&.> a:-.~ bestLow0&.>)"1 (;_1{y) allPoss"1 >0{y'  NB. y is a row of full simulation data

noteBestLows=: 3 : 0
   bl=. bestLowHands y
   if. +./valid=. (8>:{.&>bl)*.5=#&>bl do.
      which=. {.valid#/:bl
      bh=. <fixAce0"1 >,bl#~bl e. which{bl
   else. bh=. a: end.
)

fixAce0=: 3 : '(0=y)}y,:1'  NB. Ace 0->1

lowStats=: 3 : 0
  assert. *./=/"1 ] hasLow=. 0~:"1 #&>_2{."1 y
  hasLow=. {."1 hasLow
  stats=. ,:'% lows';100*(+/hasLow)%#y    NB. Start stats mat
  numTies=. #/.~ties=. #&>{."1 hasLow#_2{."1 y
  ord=. /:~.ties
  stats=. stats,('# winners: ',":ord{~.ties);<ord{numTies
  allTop2=. (1 2 3 4#5 6 7 8),&.>4 4 5 4 5 6 4 5 6 7  NB. All possible highest 2 cards
  top2=. 2{.&.>{:"1 hasLow#y
  cts=. 100*(<:#/.~allTop2,(<a.) i. &.> top2)%+/hasLow
  stats=. stats,((":&.>allTop2),&.><' high %'),.<"0 cts
)
