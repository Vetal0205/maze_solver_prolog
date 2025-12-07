
% M is a maze represented as a list of lists
% Each cell can be a f, w, s, or e.
% A is the list of directions representing the path to the exit (left, right, up, down)

goal(e).

find_exit(M, A):-
    find_start(M, Pos),
    dfs(M, Pos, A).

find_start(M, Pos) :-
    findall([X,Y], find_start_acc(M, 0, [X,Y]), All),
    All = [Pos].
find_start_acc([Row|_], Y, [X,Y]) :-
    nth0(X, Row, s).
find_start_acc([_|Rest], Y0, Pos) :-
    Y1 is Y0 + 1,
    find_start_acc(Rest, Y1, Pos).

dfs(M, Pos, Path) :-
    Visited = [],
    Stack = [frame(Pos, [])], % start pos.
    dfs_loop(M, Stack, Visited, Rev),
    reverse(Rev, Path).

dfs_loop(M, [frame(Pos, Moves)|_], _, Moves) :-
    cell(M, Pos, E),
    goal(E).

% No more nodes
dfs_loop(_, [], _, _) :-
    fail.

% Needed for way to backtrack if faced with already visited node.
% Without it will fail in next clause with no Pos to backtrack to.
dfs_loop(M, [frame(Pos, _)|Stack], Visited, Path) :-
    member(Pos, Visited),
    dfs_loop(M, Stack, Visited, Path).

dfs_loop(M, [frame(Pos, Moves)|Stack], Visited, Path) :-
    \+ member(Pos, Visited),
    Visited1 = [Pos | Visited],
    findall(node(Dir,NPos), ( move(Dir, Pos, NPos), check_wall(M, NPos), \+ member(NPos, Visited1)), Nexts),
    push_on_stack(Nexts, Moves, Stack, Stack1),
    dfs_loop(M, Stack1, Visited1, Path).

% stop when no more moves left
push_on_stack([], _, Stack, Stack). 

push_on_stack([node(Dir,NPos) | Rest], Moves, Stack, Out) :-
    NewMoves = [Dir | Moves],
    push_on_stack(Rest, Moves, [frame(NPos, NewMoves) | Stack], Out).

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