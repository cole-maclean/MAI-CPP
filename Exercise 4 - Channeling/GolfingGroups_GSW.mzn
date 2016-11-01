/* This model takes as input information about scheduling a golf schedule. Inputs in include the number of groups of golfers to make, the size of each group and the number of weeks the schedule will be made for. The schedule is constrained to ensure all players play each week, and 2 players only play in the same group together a maximum of 1 time. For this model, we build a 3-D array of [group,slot, week] = person as the objective variable.
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

array[G,S,W] of var P: X; %3-D array of [group,slot, week] = person

constraint forall(week in W)(alldifferent([ X[i,j,week] | i in G,j in S]) ); %ensure everyone plays each weel
constraint  forall(k,kprime in W where k < kprime)(
                    forall(i,iprime in G)(
                      forall(j,jprime in S where j !=jprime)(
                        forall(jdblprime,jidblprime in S where jdblprime != jidblprime)(
                            X[i,j,k] != X[iprime,jdblprime,kprime] \/ X[i,jprime,k] != X[iprime,jidblprime,kprime]
                         )
                       )
                      )
                    );
                   
%Symmetry Breaking

%Order first week players from 1..n
constraint forall(group in G)(
               forall(slot in S)(
                 X[group,slot,1] = (group-1)*sz + slot
               )
             );   
%order lowest to highest for each group       
constraint forall(week in W)(
            forall(group in G)(
              forall(slot in S where slot < sz)(
                 X[group,slot,week] < X[group,slot+1,week]
                )
              )
             );
%Order increasing first member of each consecutive group in a week        
constraint  forall(week in W)(
              forall(group in G where group < gr)(
                 X[group,1,week] < X[group+1,1,week]
              )
             );   
%Order increasing second member of first group  each week     
constraint  forall(week in W where week < we)(
                  X[1,2,week] < X[1,2,week+1]
             );
                     
solve satisfy;
output [show(X[group,slot,week]) ++ " " ++
if slot mod sz == 0 then "\n" else " " endif ++ 
if group*slot mod n == 0  then "Week" ++ show(week) ++ "\n" else "" endif ++
if group*slot mod n == 0 then "\n\n" else "" endif
| week in W,group in G, slot in S]
/*Symmetry Discussion
Unbroken symmetry solutions: 
n! · w! · w · (g!)· w · g · (s!) which for the 3x3x3 case is 2,116,316,160 possible solutions

Player and Group Symmetery Breaking = 2,592 possible solutions

All Broken Symmetries = 36 possible solutions