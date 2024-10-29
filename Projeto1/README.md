# Explanation of shortestPath Function Implementation

## Overview
The `shortestPath` function is designed to find the shortest path between two cities in a roadmap. It acts as a wrapper for the `dijkstra` function, which implements Dijkstra's algorithm to find the shortest path in a weighted graph.

## Implementation Details

### Wrapper Function: `shortestPath`

- **Input:** `RoadMap`, `City` (start), `City` (end)
- **Output:** `Path` (list of cities representing the shortest path)
- **Logic:**
  - If the start city is the same as the end city, it returns a list containing just the start city.
  - Otherwise, it calls the `dijkstra` function to compute the shortest path.

### Core Algorithm: `dijkstra`

- **Input:** `RoadMap`, `City` (start), `City` (end)
- **Output:** `Path` (list of cities representing the shortest path)
- **Logic:**
  - Uses a priority queue to explore paths, starting from the start city.
  - Keeps track of visited cities and their distances from the start city.
  - For each city, it explores its neighbors and updates the priority queue with new paths.
  - The algorithm terminates when the end city is reached, returning the shortest path.

## Auxiliary Data Structures

### Priority Queue (`queue`):

- **Purpose:** To manage the exploration of paths in order of their current total distance.
- **Structure:** A list of tuples, where each tuple contains the current distance and the path taken so far.
- **Justification:** Dijkstra's algorithm requires a way to always expand the shortest known path first. A priority queue efficiently supports this requirement.

### Visited List (`visited`):

- **Purpose:** To keep track of cities that have already been explored and their shortest known distances.
- **Structure:** A list of tuples, where each tuple contains a city and its distance from the start city.
- **Justification:** This prevents the algorithm from re-exploring cities, ensuring efficiency and correctness.

## Algorithm Description

### Initialization:

- Start with an empty list of visited cities.
- Initialize the priority queue with the start city and a distance of 0.

### Exploration Loop:

- Dequeue the path with the smallest total distance from the priority queue.
- If the current city is the end city, return the path as the shortest path.
- Otherwise, mark the current city as visited.
- For each neighbor of the current city, if it hasn't been visited, calculate the new path distance and enqueue the new path.

### Termination:

- The loop continues until the priority queue is empty or the end city is reached.
- If the end city is reached, the path is returned as the shortest path.
- If the priority queue is empty and the end city hasn't been reached, it indicates that no path exists between the start and end cities.

## Justification for Data Structures

- **Priority Queue:** Essential for Dijkstra's algorithm to ensure the shortest path is always expanded first.
- **Visited List:** Prevents re-exploration of cities, ensuring efficiency and correctness.

## Algorithm Used

- **Dijkstra's Algorithm:** A well-known algorithm for finding the shortest paths in a weighted graph with non-negative weights. It efficiently finds the shortest path by expanding the least costly paths first, using a priority queue to manage the exploration order.