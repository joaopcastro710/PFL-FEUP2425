# README

## 1. Group Information and Member Contributions

- **Group Members:**
  - João Pedro Monteiro de Castro - up202206575
  - Xavier Costa Dias de Sousa Guimarães, up202206062

- **Contribution by Percentage:**
  - João Castro: **50%** - [Task descriptions for the member (e.g., implementation of specific functions, testing, documentation).]
  - Xavier Guimarães: **50%** - 

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

