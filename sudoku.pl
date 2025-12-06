/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Sudoku CLP(FD) formulation for SWI-Prolog.

   Written Feb. 2008 by Markus Triska  (triska@metalevel.at)
   Public domain code.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

% Load the constraint logic programming library for finite domains
:- use_module(library(clpfd)).

% Load the lists library for list manipulation predicates
:- use_module(library(lists)).

% Main sudoku solver predicate
% Rows is a 9x9 list of lists representing the sudoku grid
sudoku(Rows) :-

        % Ensure Rows is a list of 9 elements
        length(Rows, 9),

        % Ensure each row has the same length as Rows (i.e., 9 columns)
        maplist(same_length(Rows), Rows),

        % Flatten the 9x9 grid into a single list Vs of 81 variables
        append(Rows, Vs), 

        % Constrain all variables to be integers in the range 1..9
        Vs ins 1..9,

        % Constraint: All elements in each row must be distinct
        maplist(all_distinct, Rows),

        % Transpose rows into columns
        transpose(Rows, Columns), 

        % Constraint: All elements in each column must be distinct
        maplist(all_distinct, Columns),

        % Decompose the 9 rows into separate variables for 3x3 block checking
        Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],

        % Constraint: Check 3x3 blocks - top 3 rows, middle 3 rows, bottom 3 rows
        blocks(As, Bs, Cs), blocks(Ds, Es, Fs), blocks(Gs, Hs, Is).

% Base case: When all three rows are empty, we're done checking blocks
blocks([], [], []).

% Recursive case: Process three rows simultaneously, taking 3 elements from each
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-

        % Constraint: All 9 elements in this 3x3 block must be distinct
        all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),

        % Recursively check the remaining elements of these three rows
        blocks(Ns1, Ns2, Ns3).

% Helper predicate to show domains for all cells
% This is useful to see how much the constraints have reduced the search space
show_domains(Rows) :-
        maplist(show_row_domains, Rows).

show_row_domains(Row) :-
        maplist(show_cell_domain, Row),
        nl.

show_cell_domain(Cell) :-
        (   integer(Cell) 
        ->  format('~w ', [Cell])  % If it's a fixed number, just show it
        ;   fd_dom(Cell, Dom),      % Otherwise show the domain
            format('~w ', [Dom])
        ).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Sample problems.
   Each problem is defined as a 9x9 grid where:
   - Numbers 1-9 are given/fixed values (clues)
   - Underscores (_) represent empty cells to be filled by the solver
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

% Problem 1: A sudoku puzzle with your specific configuration
problem(1, P) :-
        P = [[_,_,_,6,_,_,2,_,_],  % Row 1
             [8,_,4,_,3,_,_,_,_],  % Row 2
             [_,_,_,_,_,9,_,_,_],  % Row 3
             [4,_,5,_,_,_,_,_,7],  % Row 4
             [7,1,_,_,_,_,_,_,_],  % Row 5
             [_,_,3,_,5,_,_,_,8],  % Row 6
             [3,_,_,_,7,_,_,_,4],  % Row 7
             [_,_,_,_,_,1,9,_,_],  % Row 8
             [_,_,_,2,_,_,_,6,_]]. % Row 9

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Example usage:

   To solve with CLP(FD) constraints only (shows constrained but unsolved puzzle):
   ?- problem(1, Rows), sudoku(Rows), maplist(portray_clause, Rows).

   To solve completely using search (first-fail heuristic):
   ?- problem(1, Rows), sudoku(Rows),
      maplist(labeling([ff]), Rows), maplist(portray_clause, Rows).
   
   The labeling/2 predicate performs the search:
   - [ff] = "first-fail" strategy: picks variables with smallest domains first
   - This makes search more efficient by failing early on wrong choices
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
