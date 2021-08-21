NB.* game.ijs: Handle global game considerations: betting progression, incrementing blinds and assigning big and small blinds each deal, track size of pots and side-pots and who is eligible for each, allocating winnings.

coclass 'game'
NP=: 6   NB. 6 players
STAKES=: NP$1000   NB. stakes/player
NG=: 0   NB. What number game we are on

explanation=: 0 : 0
Now spawn players, assign their stakes, pick a starting player, lay down the blinds and query the 0th player to get either fold, call, or raise, and how much.  This information is now part of the game and is available to all other players, including the next one, who has the same FCR choice, and so on to the last.

Each player will have his own betting matrix and stack of chips.
)

NB. Should I do this as a vector of namespaces?

