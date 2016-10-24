/* This model takes as input the number of missions to complete, and the number of people availible to complete them, along with the upper and lower bound for both # of people in each mission plus number of missions each person can participate it. A further constraint is that for any pair of missions, at least one person must participate in both.
*/
include "globals.mzn";
int: gr; %number of groups
set of int: G=1..gr;
int: sz; %size of groups
set of int: S=1..sz;
array[1..sz] of var int: g_count;
int: n=gr*sz; %number of players
set of int: P=1..n;
int: we; % number of weeks
set of int: W=1..we;

array[P,W] of var G: X;

constraint forall(week in W, p in P)(X[p,week] in G);
constraint forall(week in W, group in G)(sum(p in P)(bool2int(X[p,week] == group)) == sz);
constraint forall(week in W)(
                  forall(weekprime in W where weekprime != week)(
                    forall(p,pprime in P where pprime < p)(
                      not(X[p,week] == X[pprime,week] /\ X[p,weekprime] == X[pprime,weekprime])
                    )
                  )
                 );

solve satisfy;

output [ show(X[player,week]) ++ "\n" ++
if player mod n == 0 then "\n\n" else "" endif
| week in W,player in P]
/*Solver Trialing -
The default Gecode solver performs comparatively poorly in solving this problem, taking substantial amounts of time to find a solution for relatively small planning configurations (anything >5 missions). The G12 lazy solving performs remarkably well, finding solutions near instantly for relatively large planning configurations (10 missions)