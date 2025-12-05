# December 5, 3:01 PM

This is the first entry in my devlog of developing program that can solve a maze using Prolog programming language. I will write a predicate find_exit/2. The first parameter is the maze, and the second will be list of actions that will olve the maze. The predicate succeeds if following the list of actions will lead from the start space to any exit space. The predicate should fail if the maze is invalid, if 
following the actions does not end in an exit space, or if an action would result in moving off the maze or onto a wall.

## 3:21 PM

First of all, map passed to find_exit predicate will be arbitrary size, with diffirent starting point. I need to find this point to start path-searching.