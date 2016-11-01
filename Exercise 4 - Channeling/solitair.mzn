include "globals.mzn";
array[int,int] of int: layout; %input shuffled deck
int:suits = 4;
set of int: cards=1..52; %List of all possible card indexes
array[1..4] of int: allowed_mods = [-1,1,-12,12];

array[1..52] of var cards: X; %Solution permutation

constraint forall(g in 1..17, s in 1..3)(X[1] != layout[g,s]); %ensure first card is the card missing from the shuffled layout
constraint alldifferent(X); %all cards are used
constraint forall(c in cards where c != 52)(exists(allw_mod in allowed_mods)((X[c+1] mod 13) - (X[c] mod 13) == allw_mod));
%constraint forall(g in 1..17)(
                  %forall(s in 1..2)(
                    %value_precede(layout[g,s],layout[g,s+1],X)
                   %)
                  %);
solve satisfy;
output [show(X)]