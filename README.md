# Poker
Simulate and study poker games: base code is in "poker", code to simulate Omaha in "Omaha", code for low poker in "lowball".
The .DAT data files each holds the data for a single, often large, variable; these are used with WS which is another repo (ws.ijs under JUtilities).

For instance, the file "SIM6.DAT" holds the results of 5,000 simulations for 6 players.  This are very simple simulations with no betting: 
all hands stay in to the end and the winners are noted.  The results of each simulation are in each row of this table:

   $sim6
5000 5
   $&.>{.sim6
+---+---+---+-+-+
|6 4|6 5|6 2|6|5|
+---+---+---+-+-+
   
The first 6x4 cell holds the hole cards for 6 players;, the 6x5 shows the best winning hand for each corresponding player; the 6x2 marks the 
hand values with column 0 being the hand type, as shown in "HandTypes", and column 1 the rank within the type; the 6-element vector ranks each
player's final hand from zero (best) to 5 (worst); the final 5-element vector is the board - the common cards.
