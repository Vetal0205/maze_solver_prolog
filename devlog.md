# December 5, 3:01 PM

This is the first entry in my devlog of developing program that can solve a maze using Prolog programming language. I will write a predicate find_exit/2. The first parameter is the maze, and the second will be list of actions that will olve the maze. The predicate succeeds if following the list of actions will lead from the start space to any exit space. The predicate should fail if the maze is invalid, if 
following the actions does not end in an exit space, or if an action would result in moving off the maze or onto a wall.

## 3:21 PM

First of all, map passed to find_exit predicate will be arbitrary size, with diffirent starting point. I need to find this point to start path-searching.

## 3:56 PM

Found nth0/3 built-in predicate to check if 's', start location, is the index’th element of list. I will stick to it instead writing my own. The 'M' in find_exit(M, A) is "Maze" passed to the predicate. The 'A' for now returns a list with 
X,Y location of 's' on 0-based arrays. It stops as soon as finds one starting point, if none found, returns false. It does
not seem maze generator predicate provided by professor can generate more than one starting point, so it is alright.