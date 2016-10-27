/* This model takes as input information about scheduling a golf schedule. Inputs in include the number of groups of golfers to make, the size of each group and the number of weeks the schedule will be made for. The schedule is constrained to ensure all players play each week, and 2 players only play in the same group together a maximum of 1 time. For this model, we build a 2-D array of [person, week] = group as the objective variable.
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

array[P,W] of var G: X; %2-D array of [person, week] = group

constraint forall(week in W, p in P)(X[p,week] in G); %ensure every player exists as part of a group for each week
constraint forall(week in W, group in G)(sum(p in P)(bool2int(X[p,week] == group)) == sz);%ensure count of players for each group is sz
constraint forall(week in W)(%ensure no 2 players play in the same group more then 1 time, ie no pair of players both play in the current week AND 
                             %any other week
                  forall(weekprime in W where weekprime != week)(
                    forall(p,pprime in P where pprime < p)(
                      not(X[p,week] == X[pprime,week] /\ X[p,weekprime] == X[pprime,weekprime])
                    )
                  )
                 );
%Symmetry Breaking        
/*constraint forall(person in P)(
                  X[person,1] < person/sz+1
                  );         
*/
        
constraint forall(person in P where person != n)(
  if person == 1 then X[person,1] = 1 elseif person mod sz == 1 then X[person,1] = X[person-1,1]+1 else X[person,1] = X[person-1,1] endif
);

constraint  forall(week in W where week != we)(
              forall(person in P)(
                  if person mod sz == 0 then X[person,week] <= X[person,week+1] else true endif
              )
             );

solve satisfy;


output [ show(X[player,week]) ++ "\n" ++
if player mod n == 0 then "\n\n" else "" endif
| week in W,player in P]
/*Symmetry Discussion