
% M is a maze represented as a list of lists
% Each cell can be a f, w, s, or e.
% A is the list of directions representing the path to the exit (left, right, up, down)

goal(e).

find_exit(M, A):-
    find_start(M, Pos),
    dfs(M, Pos, [], A).

find_start(M, Pos) :-
    find_start_acc(M, 0, Pos).
find_start_acc([Row|_], Y, [X,Y]) :-
    nth0(X, Row, s),!.
find_start_acc([_|Rest], Y0, Pos) :-
    Y1 is Y0 + 1,
    find_start_acc(Rest, Y1, Pos).

dfs(M, Pos, Visited, []) :- 
    cell(M, Pos, Element), 
    goal(Element). 
    
dfs(M, [X,Y], Visited, [Dir | Path]) :- 
    Visited1 = [[X,Y]|Visited], 
    move(Dir, [X,Y], [NX,NY]), 
    check_wall(M, [NX, NY]), 
    \+ member([NX,NY], Visited1), 
    dfs(M, [NX,NY], Visited1, Path).

check_wall(M, [NX, NY]) :-
    cell(M, [NX,NY], Cell),
    Cell \= w.

cell(M, [C, R], Value) :-
    nth0(R, M, Row),
    nth0(C, Row, Value).

move(Dir, [X,Y], [NX,NY]) :-
    Dir = left, NX is X - 1, NY is Y.
move(Dir, [X,Y], [NX,NY]) :-
    Dir = right, NX is X + 1, NY is Y.
move(Dir, [X,Y], [NX,NY]) :-
    Dir = up, NX is X, NY is Y - 1.
move(Dir, [X,Y], [NX,NY]) :-
    Dir = down, NX is X, NY is Y + 1.