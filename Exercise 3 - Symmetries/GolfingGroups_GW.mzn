/* This model takes as input information about scheduling a golf schedule. Inputs in include the number of groups of golfers to make, the size of each group and the number of weeks the schedule will be made for. The schedule is constrained to ensure all players play each week, and 2 players only play in the same group together a maximum of 1 time. For this model, we build a 2-D array of [group, week] = person as the objective variable.
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

array[G,W] of var set of P: X; %2-D array of [group, week] = person
array[int] of var set of int: week1 =  [X[group,1] | group in G];
array[int] of var set of int: group1 =  [X[1,week] | week in W];

constraint forall(week in W,g in G)(card(X[g,week]) == sz); %size of each group needs to equal input parameter sz
constraint forall(week in W)( %ensure every player plays each week (ie. no player plays in 2 groups, so interesect of any 2 groups = 0)
                  forall(g,gprime in G where gprime < g)(
                    card(X[g,week] intersect X[gprime,week]) == 0
                   )
                  );
constraint forall(week,weekprime in W where weekprime < week)( %ensure 2 players play in the same group a maximum of 1 time
                  forall(g in G)(
                    card(X[g,week] intersect X[g,weekprime]) <= 1
                   )
                  );
%Order increasing members of first week         
constraint forall(person in P where person != n)(value_precede(person,person+1,week1));   
%Order increasing first member of each group in a week          
constraint forall(week in W where week != 1)(
                  forall(group in G)(card(X[group,week] intersect {group}) = 1)
                  );
%Order increasing 2nd member of first group each week
constraint forall(week in W)(
                    card(X[1,week] intersect {week*2}) = 1
                  );

solve satisfy;

output [show(X[group,week]) ++ "\n" ++
if group mod gr  == 0 then "\n\n" else "" endif
| week in W, group in G]
/*Symmetry Discussion