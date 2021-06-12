NB.* Omaha.ijs: simulate (high-only part of) Omaha.

require '~Code/poker.ijs'
require 'WS'
PKRDIR=: '\amisc\work\Poker'

3 : 0 ''
   rr=. ''
   if. -.nameExists 'HandTypes' do. rr=. getPokerVars 'HANDRATED';'RH5';'HandTypes' end.
   rr
)

someGlobals=: 0 : 0
   CPNP=. ([: <: #/.~) &.> (<allHCcombos),&.>allHC  NB. Assumes "allHC" which could be quite large.
   allHCcombos=: a.{~/:~/:~"1 ] 4 AllCombos 52
)

getHCforNplayers=: 3 : 0
   assert. 'D:\amisc\work\Poker' -: 1!:43''
   fls=. <;._1&>' ',&.><;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread '#dir.dir'
   'full HConly'=. (('rr';'HC'),&.>nn,&.><'ply') (] #~ ([: < [) = ] {.&.>~ [: # [) &.> <1{"1 fls [ nn=. <":y
   /:~"1 (; ] extractWhatever&.>HConly),;;winningHC extractWhatever&.>full
)

NB.* rateHC: rate 4 hole cards using global CPNP (count of each combo in winning hands).
rateHC=: 3 : 0
   if. 5=#y=. <;._1 ' ',deb y do. y=. }.y [ NP=: ".;{.y end.
   cts=. (2 3 4 5 6 7 8 9 i. NP){CPNP
   tc=. cts{~allHCcombos i.a.{~/:~13#.|: showCards toupper&.>y
   (tc+/ . >cts)%#allHCcombos
NB.EG rateHC '5 6D 7H JD 2H'  NB. 5 players in game
NB.EG rateHC '2D 5C 9C QH'    NB. Same # of players as last time
)

NB. The input for the following extractors is the standard simulation result for P players:
NB. (Px4$hole cards);(Px5$best hands);(Px2 hand type, sub-type);(P$hand ranking
NB. from 0 (best) to n (worst));<5$common cards.
NB.* extractWinningHandtype: extract 2 int code of hand type, sub-type
extractWinningHandtype=: (13 : '<(0=;3{y)#>2{y')"1
NB.* extractWinningHoles: extract hole cards of winning hand(s)
extractWinningHoles=: ([: < (0 = [: ; 3 {  ]) # [: > 0 {  ])"1
extract1=: 3 : 0
   wins=. ;(extractWinningHandtype,.&.>extractWinningHoles) ".y [ unfileVar_WS_ y
   wins [ 4!:55<y
)

NB.* extractWhatever: extract per left function from all filed data items in y.
extractWhatever=: 1 : 0
   whatever [ 4!:55<y [ whatever=. u ".y [ unfileVar_WS_ y
)

tallySuits=: 13 : '<:#/.~(i.4),y'"1
rankDiffs=: 13 : '2-/\\:~y'"1
NB.* statsSR: statistics on hole cards of winning hands: suits (how many of each 
NB. 0-3),. rank diffs.
statsSR=: 3 : 0"1
   <(rankDiffs 1{"2 sr),.~tallySuits 0{"2 sr=. suitRank"1 (0=>_2{y)#>{.y
NB.EG srStats=. statsSR extractWhatever&.>nms   
)
winningHC=: 13 : '<(0=>_2{y)#>{.y'"1

NB.* updateNew: update existing simulations with new ones.
NB. ** DOES NOT WORK **
updateNew=: 3 : 0
   num=. ":num [ 'num rrpfls'=. y
   assert. 0<#nms=. tolower&.>_4}.&.>rrpfls#~(<'RR',num,'PLY')=6{.&.>rrpfls
   assert. *./;0{"1 rr=. unfileVar_WS_&>nms  NB. Able to retrieve all new ones?
   n2upd=. 'omahasim',num,'_base_'
   unfileVar_WS_ n2upd
   (n2upd)=. ~.(".n2upd),;".&.>nms
   fileVar_WS_ n2upd
   4!:55&><"0 nms
NB.EG updateNew 8;<rrpfls=. 0{"1 dir 'rr?ply*.dat'
)

NB.* summarizeWinners: some summary stats for winning hands.
summarizeWinners=: 3 : 0
   ranks=. 3{"1 y             NB. 5-column simulation mat, like "omahasim7".
   whwin=. I.&.>0=&.>ranks                        NB. Winner rank among players: 0 is best but can tie
   just1w=. 1=#&>whwin                            NB. Untied winners
   fht=. ([: , 0 { "1 ])&.>2{"1 y                 NB. Final hand type
   nways=. nways /: 1{"1 nways=. frtab #&> whwin  NB. number of n-way ties
   winners=. frtab ;just1w#(0=&.>ranks)#&.> fht   NB. Frequency table: #,.item
   pcts=. <"0 roundNums 100*(0{"1 winners)%+/just1w
   sum1=. (pcts,.(<"0]0{"1 winners),.(1{"1 winners){1}.1{"1 HandTypes) /: 0{"1 winners
   sum1=. ('%';'#';'Winning Hand'),sum1 NB. Percent, number of sole winning hand types
   nways;<sum1
NB.EG 'nways sum1'=. summarizeWinners omahasim6
)

isValidHand=: (51 *./ .>: ]) *. (0 *./ .<: ]) *. (5 *./ .= # , #@~.) *. ] *./ .= <.
poss3of5=: 13 : '(] #~ 3 = #@:~.&>) ~./:~&.>,{3$<y'
poss2of4=: 13 : '~./:~&.>(~:/&> # ]),{2$<y'
allPoss=: 13 : ';&.>,{(poss2of4 y);<poss3of5 x'

findBest0=: 4 : '1 i:~x e. y'

RH=: <"1 /:~"1 RH5
findBest=: RH&findBest0

cRH=: <"1 /:~"1 RH5{a.  NB. enc vec of char vecs
findBest=: [:>./cRH&i.  NB. Best of the findBestests

NB.* play1ToEnd: play 1 round to end for all players.
NB. Return hole cards, final ranking (0 is best) and final hand type.
play1ToEnd=: 3 : 0
   1 play1ToEnd y          NB. 1->all data
:
   np=. y [ deck=. ?~52
   'hands deck'=. (np*4) ({.;}.) deck
   holeCards=. |:(4,np)$hands
   'common deck'=.  5 ({.;}.) deck
   ph=. /:~&.>&.>(<common) allPoss &.> <"1 holeCards   NB. Possible hands for each player
   bestys=. findBest&>ph{&.>&.><<a.
   fht=. bestys{HANDRATED
NB.   maxsub=. 1{>./ HANDRATED  NB. 8 2860 -: >./ HANDRATED
   if. x do. finalHands=. bestys{RH
       htype=. (1{"1 HandTypes){~>:(;}.0{"1 HandTypes) i. 0{"1 fht
   end.
NB. fht\:~(htype,.showCards&>finalHands),.<"1 fht
   ranks=. (/:\:fht){~i.~fht       NB. Ties get same ranks, 0 is best
NB.   if. 1<0+/ . = ranks do.         NB. Tie for 1st
NB.   holeCards,.finalHands,.fht,.ranks    NB. Return 8-col int mat
   if. x do.
      holeCards;(>finalHands);fht;ranks;<common    NB. Return 5-item enc vec
   else. <holeCards#~0=ranks end.                  NB. or only hole cards of winners.
)

NB.* cardImages: write image of cards y to file x.
cardImages=: 4 : 0
   if. isNum cards=. y do. cards=. showCards y end.
   allHands=. read_image&.>cards,&.><'.png'
   allHands=. (_2{.1,$allHands)$allHands
   (|:,/1 2 0|:,/0 2 1 3|:>allHands) write_image x
)

accumWinners=: 3 : 0"1
   'hole hand rating rank common'=.  y
   (([:<([:;0{]),.[:;1{]),2}.]) ^: ([:<:@#]) ] (<0=rank)#&.>hole;hand;<rating
NB.EG winTable=. ;,accumWinners"1 ] dat   NB. [0-3] hole cards; [4-8] final hand; [9-10] hand ranking
)

NB.* e2l: Enclosed vec to simple, comma-separated, char list.
e2l=: 3 : 0
   ', ' e2l y
:
   str=. x
   (-#str)}.;y,&.><str
)

eg0=. 0 : 0
   NP=: 6
   'HANDS DECK'=: (NP*4) ({.;}.) DECK=. ?~52
   HANDS=: |:(4,NP)$HANDS
   ph=. /:~&.>&.>(<5{.DECK) allPoss &.> <"1 HANDS   NB. Possible hands for each player
   bestys=. findBest&>ph
   showCards"1 bestys{rh=. /:~"1 RH5
+---+--+--+---+--+
|QC |AC|KD|8H |AS|
+---+--+--+---+--+
|AC |KD|AD|10H|AS|
+---+--+--+---+--+
|7C |AC|KD|7S |AS|
+---+--+--+---+--+
|JC |AC|JS|QS |AS|
+---+--+--+---+--+
|AC |JD|KD|KH |AS|
+---+--+--+---+--+
|10C|JC|QD|KD |AS|
+---+--+--+---+--+
   ;}.0{"1 HandTypes
0 1 2 3 4 5 6 7 8
   \:findBest&>ph
5 1 4 3 2 0
   bestys{"1 HANDRATED
   1   3   2   2   2  4
2857 856 792 835 857 10
   showCards"1 bestys{RH5  NB. Final best hands.
)

eg1=. 0 : 0
   >./"1 HANDRATED
8 2860
   maxsub=. 1{>./"1 HANDRATED  NB. 8 2860 -: >./"1 HANDRATED
   hr=. HANDRATED
   HI=: maxsub #. |:hr
   ss=. '# Sub-hands in Poker' plotHistoMulti HI
   BKTS=: 286*i.10
   ss=. '# Sub-hands in Poker' plotHistoMulti HI

   nhpt=. +/\(0{hr) >.//. 1{hr  NB. # hands per type (pair, flush, etc.)
NB. The last one...
   ss=. '# ^.^.Sub-hands in Poker/Hand Type' plotHistoMulti ^.^.maxsub%~(0{hr) #/. 1{hr
)

egTiesHandling=. 0 : 0
   hands=. 6 4$13 5 10 49 50 42 45 30 11 23 34 48 28 44 1 27 7 26 25 47 18 17 33 8
   fht=. 6 2$1 2420 2 660 4 10 3 132 1 2850 1 1098
   tmphnd=. (3{hands),hands,2{hands    NB. Create ties
   tmpfht=. (3{fht),fht,2{fht
   tmpranks=. (/:tmpfht){~i.~tmpfht
   ([: +/ ] *./ .= |:) tmpfht  NB. ties if >1
2 1 1 2 2 1 1 2
   tmphtype=. (1{"1 HandTypes){~>:(;}.0{"1 HandTypes) i. 0{"1 tmpfht
NB. Adjust ranks so tied hands have same rank w/0 as best.   
   tmpfht\:~(<"0 (/:tmpranks){~i.~tmpfht),.(tmphtype,.showCards&>tmphnd),.<"1 tmpfht
+-+-----------+--+--+---+---+------+
|0|straight   |KC|QD|10H|JS |4 10  |
+-+-----------+--+--+---+---+------+
|0|straight   |KC|QD|10H|JS |4 10  |
+-+-----------+--+--+---+---+------+
|2|3-of-a-kind|4H|7S|3C |3H |3 132 |
+-+-----------+--+--+---+---+------+
|2|3-of-a-kind|4H|7S|3C |3H |3 132 |
+-+-----------+--+--+---+---+------+
|4|2-pair     |KS|5S|8S |6H |2 660 |
+-+-----------+--+--+---+---+------+
|5|pair       |9C|2H|AD |10S|1 2850|
+-+-----------+--+--+---+---+------+
|6|pair       |2D|7C|QC |QS |1 2420|
+-+-----------+--+--+---+---+------+
|7|pair       |7D|6D|9H |10C|1 1098|
+-+-----------+--+--+---+---+------+
)

eg2TiesHandling=. 0 : 0
   hands=. 6 4$13 5 10 49 50 42 45 30 11 23 34 48 28 44 1 27 7 26 25 47 18 17 33 8
   fht=. 6 2$1 2420 2 660 4 10 3 132 1 2850 1 1098
   tmphnd=. (2{hands),hands,2{hands    NB. Create 3-way tie for 1st
   tmpfht=. (2{fht),fht,2{fht
   i.~tmpfht
0 1 2 0 4 5 6 0
   tmpranks=. (/:tmpfht){~i.~tmpfht
   tmphtype=. (1{"1 HandTypes){~>:(;}.0{"1 HandTypes) i. 0{"1 tmpfht
NB. Adjust ranks so tied hands have same rank w/0 as best.   
   tmpfht\:~(<"0 (/:tmpranks){~i.~tmpfht),.(tmphtype,.showCards&>tmphnd),.<"1 tmpfht
+-+-----------+--+--+---+---+------+
|0|straight   |KC|QD|10H|JS |4 10  |
+-+-----------+--+--+---+---+------+
|0|straight   |KC|QD|10H|JS |4 10  |
+-+-----------+--+--+---+---+------+
|2|3-of-a-kind|4H|7S|3C |3H |3 132 |
+-+-----------+--+--+---+---+------+
|2|3-of-a-kind|4H|7S|3C |3H |3 132 |
+-+-----------+--+--+---+---+------+
|4|2-pair     |KS|5S|8S |6H |2 660 |
+-+-----------+--+--+---+---+------+
|5|pair       |9C|2H|AD |10S|1 2850|
+-+-----------+--+--+---+---+------+
|6|pair       |2D|7C|QC |QS |1 2420|
+-+-----------+--+--+---+---+------+
|7|pair       |7D|6D|9H |10C|1 1098|
+-+-----------+--+--+---+---+------+
)

smoutput 'load ''Omaha.ijs'' [ 1!:44 ''D:/amisc/work/Poker/'' [ load ''WS'''
unfileVar_WS_&>'CPNP';'allHCcombos'    NB. Globals required for "rateHC".
smoutput 'Loaded: CPNP, allHCcombos'

NB. smoutput '''D:\amisc\work\Poker'' fileVar_WS_ nm [ smoutput 6!:2 nm,''=. ; 0 play1ToEnd &>1e6$'',n [ nm=. ''HC'',n,''ply'',":nn=. 100+?1e6 [ $(<.13#.|.qts'''')?@$0 [ n=. ":6'
