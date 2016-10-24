/* This model takes as input the number of missions to complete, and the number of people availible to complete them, along with the upper and lower bound for both # of people in each mission plus number of missions each person can participate it. A further constraint is that for any pair of missions, at least one person must participate in both.
*/
include "globals.mzn";
int: gr; %number of groups
set of int: G=1..gr;
int: sz; %size of groups
set of int: S=1..sz;
int: n=gr*sz; %number of players
set of int: P=1..n;
int: we; % number of weeks
set of int: W=1..we;

array[G,S,W] of var P: X;

constraint forall(week in W)(alldifferent([ X[i,j,week] | i in G,j in S]) );
constraint  forall(k,kprime in W,
                   i,iprime in G,
                   j,jprime, jprimeiprime in S)
                   (X[i,j,k] != X[iprime,jprime,kprime] \/ X[i,jprime,k] != X[iprime,jprimeiprime,kprime] \/ k == kprime);

solve satisfy;

output [ show(X[group,slot,week]) ++ " " ++
if slot mod sz == 0 then "\n" else " " endif ++ 
if group*slot mod n == 0 then "\n\n" else "" endif
| week in W,group in G, slot in S]
/*Solver Trialing -
The default Gecode solver performs comparatively poorly in solving this problem, taking substantial amounts of time to find a solution for relatively small planning configurations (anything >5 missions). The G12 lazy solving performs remarkably well, finding solutions near instantly for relatively large planning configurations (10 missions)