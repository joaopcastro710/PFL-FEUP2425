import qualified Data.List
import qualified Data.Array
import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String    -- Type alias for a city's name
type Path = [City]    -- Type alias for a path represented as a list of cities
type Distance = Int   -- Type alias for the distance between cities

type RoadMap = [(City,City,Distance)]    -- Type for the graph with tuples (city1, city2, distance)

-- Extra graph representation types for adjacency
type AdjList = [(City, [(City, Distance)])] -- Adjacency list representation

-- Auxiliary function to remove duplicate cities
-- rmd :: Eq a => [a] -> [a]
-- Given a list, returns a list with duplicates removed
rmd :: Eq a => [a] -> [a]
rmd [] = []
rmd (x: xs) = x : rmd (filter(/= x) xs)

-- cities :: RoadMap -> [City]
-- Returns a list of unique cities in the graph
cities :: RoadMap -> [City]
cities [] = []
cities ((c1, c2, _): xs) = rmd(c1 : c2 : cities xs)

-- areAdjacent :: RoadMap -> City -> City -> Bool
-- Returns True if two cities are directly connected, False otherwise
areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent [] c1 c2 = False
areAdjacent ((city1,city2,_):xs) c1 c2
    | ((city1==c1 && city2==c2)||(city1==c2 && city2==c1)) = True
    | otherwise = areAdjacent xs c1 c2

-- distance :: RoadMap -> City -> City -> Maybe Distance
-- Returns the distance between two directly connected cities, or Nothing if they are not connected
distance :: RoadMap -> City -> City -> Maybe Distance
distance [] c1 c2 = Nothing
distance ((c1,c2,d) : xs) city1 city2
    | (city1 == c1 && city2 == c2) || (city1 == c2 && city2 == c1) = Just d
    | otherwise = distance xs city1 city2

-- adjacent :: RoadMap -> City -> [(City,Distance)]
-- Returns a list of cities directly connected to a given city along with their distances
adjacent :: RoadMap -> City -> [(City,Distance)]
adjacent roadMap city = [(if city == c1 then c2 else c1, d) | (c1, c2, d) <- roadMap, city == c1 || city == c2]

-- pathDistance :: RoadMap -> Path -> Maybe Distance
-- Returns the total distance of a path if all consecutive cities are connected; otherwise, returns Nothing
pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance [] _ = Nothing
pathDistance _ [] = Nothing
pathDistance _ [x] = Just 0
pathDistance roadMap (x:xs) = case pathDistance roadMap xs of
    Nothing -> Nothing
    Just d -> case distance roadMap x (head xs) of
        Nothing -> Nothing
        Just d' -> Just (d + d')

-- rome :: RoadMap -> [City]
-- Returns the cities with the highest number of connections (highest degree)
rome :: RoadMap -> [City]
rome [] = []
rome roadMap = 
    let tuplelist = romeadj roadMap (cities roadMap)
        maxadj = maximum [adj | (_ , adj) <- tuplelist]
    in [city | (city, adj) <- tuplelist, maxadj==adj]

romeadj :: RoadMap -> [City] -> [(City, Int)]
romeadj _ [] = []
romeadj [] _ = []
romeadj rm cities = [(city, length(adjacent rm city)) | city <- cities]

-- isStronglyConnected :: RoadMap -> Bool
-- Returns True if every city is reachable from every other city in the graph, False otherwise
isStronglyConnected :: RoadMap -> Bool
isStronglyConnected [] = True  -- Empty graph is strongly connected
isStronglyConnected roadMap =
    let allCities = cities roadMap
        startCity = head allCities
        reachableFromStart = dfs roadMap [] [startCity]
    in length reachableFromStart == length allCities

-- dfs :: RoadMap -> [City] -> [City] -> [City]
-- Depth-First Search to find all reachable cities from a starting point
dfs :: RoadMap -> [City] -> [City] -> [City]
dfs _ visited [] = visited
dfs roadMap visited (x:xs)
    | elem x visited = dfs roadMap visited xs
    | otherwise = dfs roadMap (x:visited) ([xss | (xss, _) <- adjacent roadMap x] ++ xs)

-- dijkstra :: RoadMap -> City -> City -> Path
-- Finds the shortest path between two cities using Dijkstra's algorithm
dijkstra :: RoadMap -> City -> City -> Path
dijkstra roadMap start end = explore [] [(0, [start])]
  where
    -- Helper function to explore paths from priority queue
    explore :: [(City, Distance)] -> [(Distance, Path)] -> Path
    explore _ [] = []  -- No path exists
    explore visited ((currentDist, (currentCity:currentPathTail)) : queue)
        | currentCity == end = reverse (currentCity : currentPathTail)  -- Found the shortest path
        | otherwise =
            let newVisited = (currentCity, currentDist) : visited
                newPaths = [ (currentDist + d, neighbor : currentCity : currentPathTail)
                           | (neighbor, d) <- adjacent roadMap currentCity,
                             not (neighbor `elem` map fst visited)
                           ]
                newQueue = queue ++ newPaths
            in explore newVisited newQueue

-- shortestPath :: RoadMap -> City -> City -> Path
-- Wrapper for Dijkstra to handle trivial cases and call dijkstra for others
shortestPath :: RoadMap -> City -> City -> Path
shortestPath roadMap start end
    | start == end = [start]
    | otherwise = dijkstra roadMap start end


-- travelSales :: RoadMap -> Path
-- Solves the Traveling Salesman Problem (TSP) by finding the shortest route
-- that visits each city exactly once and returns to the starting city.
-- If the roadmap is empty, has only one city, or is not connected,
-- it returns an empty path. Otherwise, it uses `actualTsp` to find the solution.
travelSales :: RoadMap -> Path
travelSales roadMap
    | null cities || length cities == 1 = []
    | not (isStronglyConnected roadMap) = []
    | otherwise = case actualTsp roadMap cities adjList of
                    Nothing -> []
                    Just path -> path ++ [head path]  -- Return to start city
    where
        cities = Data.List.nub (foldr (\(city1, city2, _) acc -> city1 : city2 : acc) [] roadMap)
        adjList = makeAdjList roadMap cities

-- makeAdjList :: RoadMap -> [City] -> AdjList
-- Converts the RoadMap to an adjacency list representation for efficient lookup.
-- Takes a list of all cities and returns an adjacency list where each city maps
-- to a list of adjacent cities and distances.
makeAdjList :: RoadMap -> [City] -> AdjList
makeAdjList roadMap cities = [(city, adjacent roadMap city) | city <- cities]

-- actualTsp :: RoadMap -> [City] -> AdjList -> Maybe Path
-- Implements the Held-Karp algorithm to solve the TSP.
-- Uses dynamic programming with bitwise operations to track visited cities.
-- Returns a `Maybe Path` indicating the optimal path, or Nothing if no path exists.
actualTsp :: RoadMap -> [City] -> AdjList -> Maybe Path
actualTsp roadMap cities adjList = 
    let bitMaskVisited = (2 ^ length cities) - 1  -- Sets first n bits to 1 (all cities visited)
        
        -- Initialize memoization array for dynamic programming
        memarray = [((i, mask), calculateTsp (cities !! i) mask) | i <- [0 .. length cities - 1], mask <- [0 .. bitMaskVisited]]
        mem = Data.Array.array ((0, 0), (length cities - 1, bitMaskVisited)) memarray
        
        -- calculateTsp :: City -> Int -> Maybe (Distance, [Int])
        -- Computes TSP solution for a city and a given visited mask
        calculateTsp :: City -> Int -> Maybe (Distance, [Int])
        calculateTsp city mask =
            if mask == bitMaskVisited  -- All cities visited
            then case distance roadMap city (head cities) of
                    Nothing -> Nothing
                    Just d -> Just (d, [0])  -- Distance back to start city
            else findNextCity city mask

        -- findNextCity :: City -> Int -> Maybe (Distance, [Int])
        -- Finds the next city to visit to minimize the total travel distance
        -- given the current city and visited mask.
        findNextCity :: City -> Int -> Maybe (Distance, [Int])
        findNextCity currentCity visitedMask = foldr tryNextCity Nothing [0 .. length cities - 1]
            where
                tryNextCity nextCityIndex acc
                    | Data.Bits.testBit visitedMask nextCityIndex = acc  -- Skip if already visited
                    | otherwise = 
                        let nextCity = cities !! nextCityIndex
                            dist = distance roadMap currentCity nextCity
                            memo = mem Data.Array.! (nextCityIndex, visitedMask Data.Bits..|. (1 `Data.Bits.shiftL` nextCityIndex))
                        in case (dist, memo) of
                            (Just d, Just (remainingDist, remainingPath)) ->
                                let newDist = d + remainingDist
                                in case acc of
                                    Nothing -> Just (newDist, nextCityIndex : remainingPath)
                                    Just (accDist, accPath) ->
                                        if newDist < accDist
                                            then Just (newDist, nextCityIndex : remainingPath)
                                            else Just (accDist, accPath)
                            _ -> acc  -- Continue with accumulator

        initialResult = mem Data.Array.! (0, 1)  -- Start from the first city with only it visited
        in do
            (_, path) <- initialResult
            return (map (cities !!) path)  -- Map path indices to city names

--------------------
tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function

---------------

-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7","6",1),("8","2",2),("6","5",2),("0","1",4),("2","5",4),("8","6",6),("2","3",7),("7","8",7),("0","7",8),("1","2",8),("3","4",9),("5","4",10),("1","7",11),("3","5",14)]

gTest2 :: RoadMap
gTest2 = [("0","1",10),("0","2",15),("0","3",20),("1","2",35),("1","3",25),("2","3",30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0","1",4),("2","3",2)]