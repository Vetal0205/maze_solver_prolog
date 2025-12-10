# December 5, 3:01 PM

This is the first entry in my devlog of developing program that can solve a maze using Prolog programming language. I will write a predicate find_exit/2. The first parameter is the maze, and the second will be list of actions that will olve the maze. The predicate succeeds if following the list of actions will lead from the start space to any exit space. The predicate should fail if the maze is invalid, if 
following the actions does not end in an exit space, or if an action would result in moving off the maze or onto a wall.

## 3:21 PM

First of all, map passed to find_exit predicate will be arbitrary size, with diffirent starting point. I need to find this point to start path-searching.

## 3:56 PM

Found nth0/3 built-in predicate to check if 's', start location, is the index’th element of list. I will stick to it instead writing my own. The 'M' in find_exit(M, A) is "Maze" passed to the predicate. The 'A' for now returns a list with 
X,Y location of 's' on 0-based arrays. It stops as soon as finds one starting point, if none found, returns false. It does
not seem maze generator predicate provided by professor can generate more than one starting point, so it is alright.

## 4:36 PM

After determining maze starting point, we need to find exit, 'e'. I will use DFS(Depth First Search) algorithm to find 
solution. The initial plan is to have the following structure for dfs/4 predicate: dfs(M, Pos, Visited, [Element | Path]). The 'Visited' field represents a stack with visited tiles. The 'Pos' is current position [X,Y]. Last argument is the solution to the maze. 

Even though the idea of DFS is clear, i stuck on understaning what does "moving" through maze means in prolog. I know i need to check coordinates, if tile is not wall 'w', we can move there and add it to Visited field. But i want to be careful here, i dont want to check/move or move to check condition twice (one to check condition and one actually writing it to the path). I want to find a way to check condition in-place without moving. I need to figure out how to check 
values in two-dimension lists. I suppose calling nth0/3 twice, one for row, one for column will work.

## 5:11 PM

Okay, i figured. First of all i need to move because i need to know row and column values, which i am moving into (so move/3 actually 
determines not only direction of moving, but also coordinates).I can move only once inside dfs function right before checking for wall, 
instead of moving both in dfs and check predicates. After moving i can check each cell But now i have problem with DFS backtracking. 
I assume the problem is in incorrect variable binding, that is,program checks whether tile is visited in wrong timing. At current moment, 
DFS algorithm pseudo working: if there is clear path to the exit, it finds it, but when it comes to backtracking it is only a possibility of success. 

## 6:37 PM

I found the issue. The actual problem was in the way i return starting tile's coordinates. When i started writing cell/3 and check_wall/3, 
i inversed Column and Row arguments by mistake. After fixing, it works correctly on random generated maps.But for some reason it does not 
work for basic map. I suppose there are edge cases i missed.
    ▐▁▁▁▍
    ▐█s█▍
    ▐  █▍
    ▐e██▍
    ▐▔▔▔▍
M = [[w, s, w], [f, f, w], [e, w, w]],
A = [right, up, right|_] .
Random map:
    ▐▁▁▁▁▁▍
    ▐   █ ▍
    ▐ ███ ▍
    ▐ █   ▍
    ▐ █ █ ▍
    ▐  s█e▍
    ▐▔▔▔▔▔▍
M = [[f, f, f, w, f], [f, w, w, w, f], [f, w, f, f, f], [f, w, f, w, f], [f, f, s, w|...]],
A = [up, up, right, right, down, down] 

## 7:04 PM

Okay, so, turned out completely messed up with axes, and previous "successful" attempts where guessing. Now axes everywhere fixed for sure
, dfs/4,cell/3 and check_wall/3 and now it computes path correctly but the are formating issues i currectly having, the "|_]" ending:
    ▐▁▁▁▁▁▍
    ▐ s █ ▍
    ▐ █ █ ▍
    ▐ ███ ▍
    ▐   e ▍
    ▐ █ █ ▍
    ▐▔▔▔▔▔▍
M = [[f, s, f, w, f], [f, w, f, w, f], [f, w, w, w, f], [f, f, f, e, f], [f, w, f, w|...]],
A = [left, down, down, down, right, right, right|_] ;

## 7:30 PM

The issue was pretty simple, in dfs base case i do not actually bind Path to anything. So when it exits variable just stays not bound:

dfs(M, Pos, Visited, Path) :- 
    cell(M, Pos, Element), 
    goal(Element). 

Corrected with:

dfs(M, Pos, Visited, []) :- 
    cell(M, Pos, Element), 
    goal(Element). 

And while i am here, i also re-wrote dfs predicate to be tail-recursive. It will decrease stack memory usage.

# December 6, 10:14 AM

Since last session, i reviewed project instruction and wanted to clarify what is an "incorrect maze." Turns out, i made wrong assumption 
about couple of starting points. The generator indeed generates correct mazes, but it does not mean someone cant pass wrong one. My code 
completely ignores this fact proceeding once it finds at least one starting point, possibly resulting in finding solution. I can fix that 
by adding check in either find_start/2 or check_wall/2 (might be the good idea to rename it then). If i choose find_start/2, i would 
probably need to rewrite entire logic, but if i choose check_wall/2 only slight corrections are needed. On other hand, choosing second 
means if we dont find another starting point while solving for exit, it will be valid, even if somewhere is another starting point. So i 
need to alter find_start/2's logic to make it work.

## 10:38 AM

Found the tool i needed, the finadll/3 built-in predicate, but it to work i had to remove cut in the end of this line: nth0(X, Row, s). 
Without cut, it searches for all possible solutions of X,Y. Here is updated find_start/2 predicate:
find_start(M, Pos) :-
    findall([X,Y], find_start_acc(M, 0, [X,Y]), All),
    All = [Pos].
Now it finds all X,Y pairs and store them in All, if only one pair is present: All = [Pos], it will succeed, fail otherwise.

## 10:51 AM

I was testing my code on bigger maps, and was constatly getting trunked output like this:
?- 
|    gen_map(4,10,10,M), display_map(M), find_exit(M,A).

    ▐▁▁▁▁▁▁▁▁▁▁▍
    ▐     █ █e ▍
    ▐  █  █    ▍
    ▐█ ████ █  ▍
    ▐     ███ █▍
    ▐  █  █    ▍
    ▐  █  ████ ▍
    ▐█ ████    ▍
    ▐   █ ██ █ ▍
    ▐ █ █ █s █ ▍
    ▐        █ ▍
    ▐▔▔▔▔▔▔▔▔▔▔▍

M = [[f, f, f, f, f, w, f, w|...], [f, f, w, f, f, w, f|...], [w, f, w, w, w, w|...], [f, f, f, f, f|...], [f, f, w, f|...], [f, f, w|...], [w, f|...], [f|...], [...|...]|...],

A = [right, up, up, right, right, up, up, left, up|...] .

To fix this i run following query (i will also include it in README file):

?- set_prolog_flag(answer_write_options, [max_depth(0)]).

# December 7, 10:46 AM

For this session i plan make additional testing using gen_map/4 predicate. Specifically, testing on large mazes (20x20 and bigger) with 
different "density" (number of iterations the algorithm should go through), starting from 4 and ending maze dimension / 2. If we set upper 
bound bigger than dimension / 2, there is no further noticable difference.

## 11:14 AM

I was trying various configuration, all worked fine except for big mazes with low density, like in gen_map(4, 20, 20, M). There is a lot of 
empty spaces in the maze making DFS algorithm ran out of stack memory. It means i did not make my code tail-recursive. I will try to do it
in separate branch.

## 12:39 AM (tail_recursive_dfs)

After some research, here is what i need to do: i need to get rid of recusion (creating new activation records), meaning i need to switch 
from dynamic activation records to static data structures. Which in turn mean, i need to handle stack myself (it will have positions and 
their partial paths). Since there is no recursion, we cannot backtrack, so we will just be pushing valid moves onto the our stack for later
processing. Each new path segment now will be stored directly inside the stack entry.

## 3:12 PM (tail_recursive_dfs)

Converted the recursive DFS into its loop version. The loop behaves as follows: 

    it inspects the top of the stack; 
    if the position matches our goal (exit), 
        it returns the stored path; 
    if the stack is empty, 
        the search fails (no valid moves left and no goal was reached). 
    When the position has already been visited, 
        the loop discards that entry and continues 
        (need both member(...) and \+ member(...) so the program does not stop when faced visited node). 
    When the position is new, 
        it is added to the visited set, all valid neighbors are generated and pushed as new stack entry with the extended path,
        and then loop repeats.

# December 10, 5:23 PM

Today i plan to do final testing before submiting project. Before i tested my predicate with unbound variable for solution, meaning, find 
"A" that results in solved maze. Now i want to check inverse behavior, pass solution, and check whether it is true. 

## 5:49 PM

I noticed that when we pass the path like:

?- basic_map(M), display_map(M), find_exit(M,[down,up,down, left, down]).

    ▐▁▁▁▍
    ▐█s█▍
    ▐  █▍
    ▐e██▍
    ▐▔▔▔▍
false.

It results to be false. Which will seem weird, since the path is resulting in exit tile. The problem is that my dfs/4 predicate calculates
the solution taking into account visited tiles. Therefore it is impossible to prove path that does loops. To counter that i created new 
predicate valid_path/3 to "check" passed path to result in exit even if there are loops (revisited nodes).