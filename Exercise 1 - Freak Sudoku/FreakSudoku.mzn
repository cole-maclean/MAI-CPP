/* This model takes as input a horizontal and a vertical equality statements (">","<","v","^") table, and interger S indicating the number of SxS sub puzzles within ab S^2xS^2 full puzzle space, following the rules of sudoku. The solution solves the puzzle for the usual constraints of suduko, plus the 
satisfaction of the inputted horizontal and vertical equalities. If the input equality tables are incomplete, the solutions will fill in satisfiable equality tables given the partial input
*/

include "alldifferent.mzn";
int: S; %SxS dimension of sub puzzles
int: N = S * S; %NxN dimension of total puzzle
int: EQD = (S-1) * S; % Corrected dimensions of equality table horizonal = NxEQD, vertical = EQDxN

int: digs = ceil(log(10.0,int2float(N))); % digits for output
set of int: PuzzleRange = 1..N;
set of int: SubSquareRange = 1..S;
array[1..N,1..EQD] of string: horizontal; % horizonal inequalities from input file
array[1..EQD,1..N] of string: vertical; % vertical inequalities from input file
array[1..N,1..N] of var PuzzleRange: puzzle; % initialize NxN array of the Puzzle Board

% All different in rows
constraint forall (i in PuzzleRange) (
alldifferent( [ puzzle[i,j] | j in PuzzleRange ]) );
% All different in columns.
constraint forall (j in PuzzleRange) (
alldifferent( [ puzzle[i,j] | i in PuzzleRange ]) );
% All different in sub-squares:
constraint
forall (a, o in SubSquareRange)(
alldifferent( [ puzzle[(a-1) *S + a1, (o-1)*S + o1] |
a1, o1 in SubSquareRange ] ) );

% Satisfy Horizontal Equalities:
constraint forall (i in PuzzleRange) ( %iterate over all of the rows of the puzzle board, and all columns, skipping the right edge column of each
                                       %sub puzzle ie. any column with index mod S equal to 0
  forall(j in PuzzleRange where j mod S != 0) (
    if horizontal[i,j-floor(j/S)] == ">" then puzzle[i,j] > puzzle[i,j+1] %lookup equality in horizontal data table, if ">" then puzzlei,j > puzzlei,j+1
    else if horizontal[i,j-floor(j/S)] == "<" then puzzle[i,j] < puzzle[i,j+1]
    else 1==1 endif endif %1==1 means uncontrained on puzzlei,j if equality is anything other then ">" or "<", ie "" or "0" indicates unconstrained
  )
);
% Satisfy Vertical Equalities:
%same as horizontal iteration, except indexed over the rows with "v" being the greater-than indicator and "^" is less-than
constraint forall (j in PuzzleRange) (
  forall(i in PuzzleRange where i mod S !=0) (
    if vertical[i-floor(i/S),j] == "v" then puzzle[i,j] > puzzle[i+1,j]
    else if vertical[i-floor(i/S),j] == "^" then puzzle[i,j] < puzzle[i+1,j]
    else 1==1 endif endif
  )
);

solve satisfy;
%output the puzzle solutions plus any satisfiable equality tables given incomplete input equality tables
output [ show_int(digs,puzzle[i,j]) ++ " " ++
if j mod S == 0 then " " else "" endif ++
if j == N /\ i != N then
if i mod S == 0 then "\n\n" else "\n" endif
else "" endif
| i,j in PuzzleRange ] ++ ["\n"] ++
[ 
if j-1 mod EQD == 0 then "\n" else " " endif ++
show(if (puzzle[i,j] > puzzle[i,j+1]) then ">" else "<" endif)
| i,j in PuzzleRange where j mod S != 0 ] ++ ["\n\n"] ++
[ 
show(if (puzzle[i,j] > puzzle[i+1,j]) then "v" else "^" endif) ++
if j mod N == 0 then "\n" else " " endif
| i,j in PuzzleRange where i mod S != 0 ] ++ ["\n"];
