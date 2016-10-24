/* This model takes as input the number of missions to complete, and the number of people availible to complete them, along with the upper and lower bound for both # of people in each mission plus number of missions each person can participate it. A further constraint is that for any pair of missions, at least one person must participate in both.
*/
include "globals.mzn";
int: n; % number of people
int: m; % number of missions

array[1..m] of int: lm; %mission capacity lower limit
array[1..m] of int: um; %mission capacity upper limit
array[1..n] of int: lp; %person participation lower limit
array[1..n] of int: up; %person participation upper limit

set of int: missions = 1..m; %set of missions for mission indexing
set of int: people = 1..n; %set of people for people indexing
array[1..n] of var int: p_count; %storage variable for individual mission participation counts
array[1..m] of var set of people: plan; %objective variable - an array of sets of people in each mission

constraint forall(i in missions)(card(plan[i]) >= lm[i] /\ card(plan[i]) <= um[i]);%constrain capacity limits of each mission
constraint forall(p in people)( %constain individual participation limits
           p_count[p] = sum(i in missions)(p in plan[i])
           /\ p_count[p] >= lp[p]
           /\ p_count[p] <= up[p]
           );
constraint forall(i in missions,j in missions where i != j)(card(plan[i] intersect plan[j]) >= 1);%ensure instersection of at least 1 person for any 
                                                                                                  %pair of missions

solve satisfy;

output ["plan = ", show(plan), ";\n"];

/*Solver Trialing -
The default Gecode solver performs comparatively poorly in solving this problem, taking substantial amounts of time to find a solution for relatively small planning configurations (anything >5 missions). The G12 lazy solving performs remarkably well, finding solutions near instantly for relatively large planning configurations (10 missions)