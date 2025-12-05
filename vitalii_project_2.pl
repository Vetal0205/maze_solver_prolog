
% M is a maze represented as a list of lists
% A is the list of directions representing the path to the exit (left, right, up, down)

find_exit(M, A):-
    find_start(M, A).

find_start(M, Pos) :-
    find_start_acc(M, 0, Pos).
find_start_acc([Row|_], Y, [X,Y]) :-
    nth0(X, Row, s),!.
find_start_acc([_|Rest], Y0, Pos) :-
    Y1 is Y0 + 1,
    find_start_acc(Rest, Y1, Pos).