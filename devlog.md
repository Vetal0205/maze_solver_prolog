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