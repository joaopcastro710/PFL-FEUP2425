# README

## 1. Group Information and Member Contributions

- **Group Members:**
  - João Pedro Monteiro de Castro - up202206575
  - Xavier Costa Dias de Sousa Guimarães, up202206062

- **Contribution by Percentage:**
  - João Castro: **50%** - Functions 1, 2, 3, 4, 7, 8, readme description of problem 8 , code comments and testing
  - Xavier Guimarães: **50%** - Functions 5, 6, 9, readme description of problem 9, code comments and testing

## 2. Shortest Path Function (`shortestPath`)

- **Implementation Overview**:
  - The `shortestPath` function calculates the shortest path between two cities on a roadmap.
  - The function is based on Dijkstra’s algorithm, which is designed to handle graphs with non-negative weights efficiently.
  - The function handles trivial cases where the start and end cities are the same by returning a single-element path.

- **Justification for Data Structures**:
  - We use adjacency lists through the [`adjacent`] function, which retrieves neighboring cities and distances in an efficient manner, making it suitable for Dijkstra’s algorithm.
  - The roadmap representation (`RoadMap`) as a list of tuples is preserved throughout, as it is straightforward and compatible with list operations required by Dijkstra's approach.
  - The use of a priority queue (implemented as a list of tuples) in the `explore` function allows for efficient exploration of the least-costly paths.

- **Algorithm Description**:
  - **Dijkstra's Algorithm** is used to progressively explore the least-costly paths to reach the destination city. This algorithm performs well with sparse graphs and ensures optimal pathfinding by exploring neighbors of each city in priority order.
  - The algorithm starts by initializing a priority queue with the starting city and a distance of zero.
  - It then iteratively explores the city with the smallest accumulated distance, updating the distances to its neighbors if a shorter path is found.
  - The algorithm maintains a list of visited cities to avoid reprocessing and ensures that each city is processed only once.
  - The `explore` function is a helper function that manages the priority queue and explores new paths by adding neighboring cities to the queue.
  - The `shortestPath` function wraps the Dijkstra algorithm, handling trivial cases where the start and end cities are the same by returning a single-element path.

## 3. Traveling Salesman Function (`travelSales`)

- **Implementation Overview**:
  - The `travelSales` function returns a solution to the TSP (Traveling Salesman Problem) of a given RoadMap.
  - We implemented a dynammic programming approach, dividing the problem at hand into several subproblems (the shortest path from a given city to itself whilst passing through all other cities once) and storing the results using a memoization table to facilitate the computation of the solution.
 
- **Justification for Data Structures**:
  - We use the makeAdjList function to map an array of neighbouring cities and their distances to a given city, therefore we naturally made use of the Adjacency List data structure suggested to us by the project's assignment paper as it provides a quick and simple way to access that data, which came in handy when developing our algorithm.
  - We also made use of a bit mask (which we manipulated using some Data.Bits library functions) to easily identify and monitor which cities have already been visited in each path the algorithm checks.
  - Additionally, we opted to use a memoization array to store the several results of subproblems we obtained, further improving the complexity of our solution, as this prevents computing paths we already computed.

- **Algorithm Description**:
  - The algorithm starts by checking the base cases (empty roadMap or a single city roadMap), checking whether or not the roadMap is connected (making use of the `IsStronglyConnected` function we developed in a previous problem) and if so it calls the `actualTsp` function. In this function we create a bitmask to track the visited cities in every path we discover. We also initialize a memoization array to store the shortest tsp path of every given city and its cost. We then call the recursive `calculateTSP` helper function which computes the minimum path cost ending in a given city (and holds the visited cities in a mask), then checks if the given bitmask is complete and if not it calls `findNextCity`. This function's purpose is to find the next city of the path that's being processed. For every valid destination it updates the bit mask accordingly, retrieves the memoized result fo the given destination and bit mask and updates the minimum distance if a shorter path is found. After filling the memoization array we retrieve the optimal result. A short mention is also necessary for the `makeAdjList` function which, as the name says, maps an array of neighbours and its distance to a given city.
