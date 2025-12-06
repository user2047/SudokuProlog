# Sudoku Solver using CLP(FD)

A Prolog-based Sudoku solver using **Constraint Logic Programming over Finite Domains (CLP(FD))** in SWI-Prolog.

## Overview

This implementation demonstrates how constraint propagation and search work together to solve Sudoku puzzles efficiently. The solver uses CLP(FD) constraints to:
- Ensure all cells contain values 1-9
- Enforce distinctness in rows, columns, and 3×3 blocks
- Reduce the search space before any search begins

## Requirements

- **SWI-Prolog** (version 7.0 or later)
  - Download from: https://www.swi-prolog.org/download/stable
  - The solver uses built-in libraries: `library(clpfd)` and `library(lists)`

## Usage

### Solve with Constraints and Search

Run the complete solver with first-fail search strategy:

```prolog
?- problem(1, Rows), sudoku(Rows), 
   maplist(labeling([ff]), Rows), 
   maplist(portray_clause, Rows).
```

### View Constraints Only (No Search)

See the puzzle with constraints applied but variables uninstantiated:

```prolog
?- problem(1, Rows), sudoku(Rows), 
   maplist(portray_clause, Rows).
```

### Visualize Constrained Domains

See what values are possible for each cell after constraint propagation:

```prolog
?- problem(1, Rows), sudoku(Rows), show_domains(Rows).
```

This shows how much the constraints reduce the search space before labeling begins.

## Command Line Usage

### Full Solution
```bash
swipl -s sudoku.pl -g "problem(1, Rows), sudoku(Rows), maplist(labeling([ff]), Rows), maplist(portray_clause, Rows)" -t halt
```

### Show Domains
```bash
swipl -s sudoku.pl -g "problem(1, Rows), sudoku(Rows), show_domains(Rows)" -t halt
```

## How It Works

### 1. Constraint Propagation
The `sudoku/1` predicate sets up three types of constraints:
- **Row constraints**: All values in each row must be distinct
- **Column constraints**: All values in each column must be distinct  
- **Block constraints**: All values in each 3×3 block must be distinct

These constraints dramatically reduce possible values for each cell.

### 2. Search (Labeling)
The `labeling([ff], Rows)` performs search using the **first-fail** strategy:
- Selects variables with smallest domains first
- Makes search more efficient by failing early on wrong choices
- Explores remaining possibilities systematically

### 3. The Power of CLP(FD)
CLP(FD) constraints do the "smart" work:
- Eliminate impossible values through propagation
- Reduce search space from 9^81 to a manageable size
- Most of the solving happens before search even begins!

## Example Puzzle

The included puzzle (problem 1):
```
_ _ _ 6 _ _ 2 _ _
8 _ 4 _ 3 _ _ _ _
_ _ _ _ _ 9 _ _ _
4 _ 5 _ _ _ _ _ 7
7 1 _ _ _ _ _ _ _
_ _ 3 _ 5 _ _ _ 8
3 _ _ _ 7 _ _ _ 4
_ _ _ _ _ 1 9 _ _
_ _ _ 2 _ _ _ 6 _
```

Solution:
```
9 7 1 6 8 4 2 3 5
8 6 4 5 3 2 7 9 1
5 3 2 7 1 9 4 8 6
4 8 5 9 6 3 1 2 7
7 1 6 4 2 8 3 5 9
2 9 3 1 5 7 6 4 8
3 2 9 8 7 6 5 1 4
6 5 8 3 4 1 9 7 2
1 4 7 2 9 5 8 6 3
```

## Adding Your Own Puzzles

Define new puzzles using the `problem/2` predicate:

```prolog
problem(2, P) :-
    P = [[_,_,_,_,_,_,_,_,_],
         [_,_,_,_,_,_,_,_,_],
         % ... define your puzzle here
         [_,_,_,_,_,_,_,_,_]].
```

Then solve with: `problem(2, Rows), sudoku(Rows), maplist(labeling([ff]), Rows).`

## Code Structure

- `sudoku/1` - Main solver predicate with constraint setup
- `blocks/3` - Recursive checking of 3×3 block constraints
- `show_domains/1` - Helper to visualize constrained domains
- `problem/2` - Puzzle definitions

## Learning Resources

This implementation is excellent for understanding:
- How constraint logic programming works
- The relationship between constraints and search
- List pattern matching in Prolog (`[N1,N2,N3|Ns1]`)
- The `maplist/2` higher-order predicate
- Domain reduction through constraint propagation

For more on CLP(FD) and constraint programming:
- [SWI-Prolog CLP(FD) Documentation](https://www.swi-prolog.org/man/clpfd.html)
- [The Power of Prolog - CLP(FD)](https://www.metalevel.at/prolog/clpfd)

## License

Public domain code. Original Sudoku formulation by Markus Triska (2008).


* *find* a single solution
* *enumerate* all solutions
* *complete* partially instantiated solutions
* *validate* fully instantiated solutions.

To get an idea of the power, usefulness and scope of CLP(ℤ)
constraints, I recommend you work through the examples in the
following order:

1. [**n_factorial.pl**](n_factorial.pl): Shows how to use CLP(ℤ)
   constraints for **declarative integer arithmetic**, obtaining very
   general programs that can be used in all directions. Declarative
   integer arithmetic is the simplest and most common use of CLP(ℤ)
   constraints. They are easy to understand and use this way, and
   often increase generality and logical purity of your code.

2. [**sendmory.pl**](sendmory.pl): A simple cryptoarithmetic puzzle.
   The task is to assign one of the digits 0,...,9 to each of the
   letters S,E,N,D,M,O,R and Y in such a way that the following
   calculation is valid, and no leading zeroes appear:

            S E N D
          + M O R E
          ---------
        = M O N E Y

   This example illustrates several very important concepts:

   * It is the first example that shows **residual constraints** for the
     most general query. They are equivalent to the original query.

   * It is good practice to separate the **core relation** from
     `labeling/2`, so that termination and determinism can be observed
     without an expensive search for concrete solutions.

   * You can use this example to illustrate that the CLP(ℤ) system is able
     to **propagate** many things that can also be found with human
     reasoning. For example, due to the nature of the above calculation and
     the prohibition of leading zeroes, `M` is necessarily 1.

3. [**sudoku.pl**](sudoku.pl): Uses CLP(ℤ) constraints to model and
   solve a simple and well-known puzzle. This example is well suited
   for understanding the impact of different **propagation
   strengths**: Use it to compare `all_different/1` `all_distinct/1`
   on different puzzles:

   ![](figures/filler.png) ![Sudoku with all_different/1](figures/sudoku_all_different.png) ![](figures/filler20.png) ![Sudoku with all_distinct/1](figures/sudoku_all_distinct.png)

   The small dots in each cell indicate how many elements are pruned
   by different **consistency techniques**. In many Sudoku puzzles,
   using `all_distinct/1` makes labeling unnecessary. Does this mean that
   we can forget `all_different/1` entirely?

   **Video**: https://www.metalevel.at/prolog/videos/sudoku

4. [**magic_square.pl**](magic_square.pl): CLP(ℤ) formulation of [*magic
   squares*](http://mathworld.wolfram.com/MagicSquare.html). This is a good
   example to learn about **symmetry breaking** constraints: Consider how
   you can eliminate solutions that are rotations, reflections etc. of
   other solutions, by imposing suitable further constraints. For example,
   the following two solutions are essentially identical, since one can be
   obtained from the other by reflecting elements along the main diagonal:

   ![](figures/filler.png) ![Magic square solution](figures/magic_square1.png) ![](figures/filler20.png) ![Magic square transposed](figures/magic_square2.png)

   Can you impose additional constraints so that you get only a single
   solution in such cases, without losing any solutions that do not
   belong to the same equivalence class? How many solutions are there
   for N=4 that are unique up to isomorphism?

5. [**magic_hexagon.pl**](magic_hexagon.pl): Uses CLP(ℤ) to describe a
   [*magic hexagon*](http://mathworld.wolfram.com/MagicHexagon.html) of
   order 3. The task is to place the integers 1,...,19 in the following
   grid so that the sum of all numbers in a straight line (there are lines
   of length 3, 4 and 5) is equal to 38. One solution of this task is shown
   in the right picture:

   ![](figures/filler.png) ![Magic hexagon grid](figures/magic_hexagon.png) ![](figures/filler20.png) ![Magic hexagon solution](figures/magic_hexagon_solution.png)

   This is an example of a task that looks very simple at first, yet
   is almost impossibly hard to solve manually. It is easy to solve
   with CLP(ℤ) constraints though. Use the constraint solver to show
   that the solution of this task is unique up to isomorphism.

6. [**n_queens.pl**](n_queens.pl): Model the so-called [*N-queens
   puzzle*](https://en.wikipedia.org/wiki/Eight_queens_puzzle) with
   CLP(ℤ) constraints. This example is a good candidate to experiment
   with different **search strategies**, specified as options of
   `labeling/2`. For example, using the labeling strategy `ff`, you
   can easliy find solutions for 100 queens and more. Sample solutions
   for 8 and 50 queens:

   ![](figures/filler.png) ![Solution for 8 queens](figures/queens8_solution.png) ![](figures/filler20.png) ![Solution for 50 queens](figures/queens50_solution.png)

   Try to find solutions for larger N. Reorder the variables so that
   `ff` breaks ties by selecting more central variables first.

   **Video**: https://www.metalevel.at/prolog/videos/n_queens

7. [**knight_tour.pl**](knight_tour.pl): Closed Knight's Tour using
   CLP(ℤ) constraints. This is an example of using a more complex
   **global constraint** called `circuit/1`. It shows how a problem
   can be transformed so that it can be expressed with a global
   constraint. Sample solutions, using an 8x8 and a 16x16 board:

   ![](figures/filler.png) ![Closed knight's tour on an 8x8 board](figures/knight8_solution.png) ![](figures/filler20.png) ![Closed knight's tour on a 16x16 board](figures/knight16_solution.png)

   Decide whether `circuit/1` can also be used to model tours that are
   not necessarily closed. If not, why not? If possible, do it.

8. [**tasks.pl**](tasks.pl): A task scheduling example, using the
   `cumulative/2` global constraint. The `min/1` labeling option is
   used to minimize the total duration.

   ![](figures/filler.png) ![Task scheduling](figures/tasks.png)

## Animations

When studying Prolog and CLP(ℤ) constraints, it is often very useful
to show *animations* of search processes. An instructional example:

[**N-queens animation**](https://www.metalevel.at/queens/): This
visualizes the search process for the N-queens example.

You can use similar PostScript instructions to create [custom
animations](https://www.metalevel.at/postscript/animations) for
other examples.

## A limited alternative: Low-level integer arithmetic

Suppose for a moment that CLP(ℤ) constraints were not available in
your Prolog system, or that you do not want to use them. How do we
formulate `n_factorial/2` with more primitive integer arithmetic?

In our first attempt, we simply replace the declarative CLP(ℤ)
constraints by lower-level arithmetic predicates and obtain:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            F is N * F1,
            n_factorial(N1, F1).

Unfortunately, this does not work at all, because lower-level
arithmetic predicates are *moded*: This means that their arguments
must be sufficiently instantiated at the time they are invoked.
Therefore, we must reorder the goals and&nbsp;&mdash; somewhat
annoyingly&nbsp;&mdash; change this for example to:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            n_factorial(N1, F1),
            F is N * F1.

Naive example queries inspired more by *functional* than by
*relational* thinking may easily mislead us into believing that this
version is working correctly:

    ?- n_factorial(6, F).
    F = 720 ;
    false.

Another example:

    ?- n_factorial(3, F).
    F = 6 ;
    false.

But what about *more general* queries? For example:

    ?- n_factorial(N, F).
    N = 0,
    F = 1 ;
    ERROR: n_factorial/2: Arguments are not sufficiently instantiated

Unfortunately, this version thus cannot be directly used to enumerate
more than one solution, which is another severe drawback in comparison
with the more general version.

You can make the deficiency a lot worse by arbitrarily adding
a&nbsp;`!/0` somewhere. Using `!/0` is a quite reliable way to destroy
almost all declarative properties of your code in most cases, and this
example is no exception:

    n_factorial(0, 1) :- !.
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            n_factorial(N1, F1),
            F is N * F1.

This version appears in several places. The fact that the following
interaction *incorrectly* tells us that there is exactly one solution of
the factorial relation is apparently no cause for concern there:

    ?- n_factorial(N, F).
    N = 0,
    F = 1.

Zero and one are the only important integers in any case, if you are
mostly interested in programming at a very low level.

For more usable and general programs, I therefore recommend you stick
to CLP(ℤ) constraints for integer arithmetic. You can place pure
goals in any order without changing the declarative meaning of your
program, just as you would expect from logical conjunction. For
example:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            n_factorial(N1, F1),
            F #= N * F1.

Reordering pure goals can change **termination properties**, but it
cannot incorrectly lead to failure where there is in fact a solution.
Therefore, we get with the above CLP(ℤ) version for example:

    ?- n_factorial(N, 3).
    <loops>

And now we can reason completely declaratively about the code: Knowing
that (a)&nbsp;CLP(ℤ) constraints are *pure* and can thus be reordered
quite liberally and (b)&nbsp;that posting CLP(ℤ) constraints *always
terminates*, we *know* that placing CLP(ℤ) constraints earlier can at
most *improve*, never *worsen* the desirable termination properties.

Therefore, we change the definition to the version shown initially:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            F #= N * F1,
            n_factorial(N1, F1).

The sample query now terminates:

    ?- n_factorial(N, 3).
    false.

Using CLP(ℤ) constraints has allowed us to improve the termination
properties of this predicate by purely declarative reasoning.

## Acknowledgments

I am extremely grateful to:

[**Ulrich Neumerkel**](http://www.complang.tuwien.ac.at/ulrich/), who
introduced me to constraint logic programming.

[**Nysret Musliu**](http://dbai.tuwien.ac.at/staff/musliu/), my thesis
advisor, whose interest in combinatorial tasks and constraint
satisfaction highly motivated me to work in this area.

[**Mats Carlsson**](https://www.sics.se/~matsc/), the designer and
main implementor of SICStus Prolog and its superb [CLP(FD)
library](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/lib_002dclpfd.html#lib_002dclpfd)
which spawned my interest in constraints.
