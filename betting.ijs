NB.* betting.ijs: betting on Omaha.

NB.* play1WithBetting: play a round of Omaha with betting.
play1WithBetting=: 3 : 0
    betMats=. y     NB. NP*4*3 mats to define betting strategy per player.
    np=. #betMats   NB. # of players
    deck=. ?~52
    'hands deck'=. (np*4) ({.;}.) deck  NB. Start with 4 hole cards/player.
    for_stage. i.1{$betMats do.
    end.
)

initialWork=. 0 : 0
   betmat=. (4{.'Portion/Stage';":&.>(]%>./)>:i.3),4 4$a:
   rowtit=. ('Pre-flop';'Flop';'Turn';'River')
   betmat=. (({.{.betmat),rowtit) 0}&.|: betmat
0 : 0
   betmat
+-------------+--------+--------+-+
|Portion/Stage|0.333333|0.666667|1|  NB. Portion of holdings ->
+-------------+--------+--------+-+  NB. Stage of game
|Pre-flop     |        |        | |
+-------------+--------+--------+-+
|Flop         |        |        | |
+-------------+--------+--------+-+
|Turn         |        |        | |
+-------------+--------+--------+-+
|River        |        |        | |
+-------------+--------+--------+-+
)

initialWork=. 0 : 0
   betodds=. (<./,:>./) 2 4 3?@$0   NB. 0{Minimum and 1{maximum bet as portion of holdings
0 : 0   
   betodds
0.946262  0.505672 0.084712
 0.20671  0.262482 0.540054
0.630206  0.465234 0.184449
0.114238 0.0991282 0.174741

0.965094  0.664519 0.776017
0.307362  0.840877 0.591713
0.707342   0.99119 0.221416
0.428598  0.956787 0.742911
)   

initialWork=. 0 : 0
   betodds=. (]%+/)"1 \:~"1 ] 4 3?@$0   NB. Min hand percentile (0:worst, 1:best) to bet up to (1 2 3%3) portion of holdings.

0 : 0
   betodds
0.499264  0.30297  0.197766
0.824417  0.10513 0.0704528
0.483831 0.374976  0.141193
0.483483 0.445196 0.0713207
)

initialWork=. 0 : 0
   betodds=. (]%+/)"1 /:~"1 ] 4 3?@$0   NB. Min hand percentile (0:worst, 1:best) to bet up to (1 2 3%3) portion of holdings.
0 : 0
   betodds
0.111674 0.439558 0.448768
0.181217 0.404482 0.414301
0.172554 0.400927 0.426519
0.236118 0.352464 0.411419
)   

initialWork=. 0 : 0
   betodds=. /:~"1&.|:/:~"1 ] 4 3?@$0   NB. Min hand percentile (0:worst, 1:best) to bet up to (1 2 3%3) portion of holdings.
0 : 0
   betodds
0.055798 0.503611 0.712551
0.220872 0.651583 0.851277
0.606219 0.710434 0.905296
0.834003  0.83782 0.911674

   (<"0 betodds) ixs}betmat
+------------+--------+--------+--------+
|Betting/Turn|0.333333|0.666667|1       |
+------------+--------+--------+--------+
|Pre-flop    |0.055798|0.503611|0.712551|
+------------+--------+--------+--------+
|Flop        |0.220872|0.651583|0.851277|
+------------+--------+--------+--------+
|Turn        |0.606219|0.710434|0.905296|
+------------+--------+--------+--------+
|River       |0.834003|0.83782 |0.911674|
+------------+--------+--------+--------+
The requirement for staying goes up as more money is required for
the bet and the mininum for staying also goes up as the game
progresses.

What about initiating a bet rather than responding to one?

Perhaps look at where my hand is across the board and initiate a bet if I'm 
in the "all-in" category: my hand is at or above the percentile
in the "1" column.  So how much to bet?

For now, maybe the next category down?  So, if I have an "all-in" hand, I bet 0.67 of my holdings; if I have a middle third hand, I bet 0.33 of my holdings.
)
