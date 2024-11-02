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


-- 9
-- Convert City names to indices and vice versa
cityIndex :: [City] -> City -> Int
cityIndex cityList city = case Data.List.elemIndex city cityList of
    Just i -> i
    Nothing -> error "City not found in list"

indexCity :: [City] -> Int -> City
indexCity cityList index = cityList !! index

-- Initialize the distance matrix from a RoadMap and city list
initDistanceMatrix :: RoadMap -> [City] -> Data.Array.Array (Int, Int) (Maybe Distance)
initDistanceMatrix roadMap cityList =
    let n = length cityList
    in Data.Array.array ((0, 0), (n - 1, n - 1))
        [((i, j), findDistance (indexCity cityList i) (indexCity cityList j) roadMap)
        | i <- [0 .. n - 1], j <- [0 .. n - 1]]
  where
    findDistance :: City -> City -> RoadMap -> Maybe Distance
    findDistance c1 c2 [] = Nothing
    findDistance c1 c2 ((a, b, d):xs)
      | (c1 == a && c2 == b) || (c1 == b && c2 == a) = Just d
      | otherwise = findDistance c1 c2 xs

-- Main TSP function using the Held-Karp algorithm
travelSales :: RoadMap -> Path
travelSales roadMap = case reconstructPath (0, allVisited) of
    [] -> []  -- If no valid path, return empty list
    path -> map (indexCity citiesList) (path ++ [0])  -- Append start city to complete the cycle
  where
    citiesList = cities roadMap
    n = length citiesList
    allVisited = (1 `Data.Bits.shiftL` n) - 1
    distMatrix = initDistanceMatrix roadMap citiesList

    -- Memoization table for dynamic programming
    memoTable :: Data.Array.Array (Int, Int) (Maybe (Distance, Int))
    memoTable = Data.Array.array ((0, 0), (n - 1, allVisited))
        [((i, visited), heldKarp i visited) | i <- [0 .. n - 1], visited <- [0 .. allVisited]]

    -- Recursive Held-Karp function with memoization, includes return to start
    heldKarp :: Int -> Int -> Maybe (Distance, Int)
    heldKarp current visited
      | visited == 0 = case distMatrix Data.Array.! (current, 0) of
                         Just d -> Just (d, 0)  -- Distance back to start
                         Nothing -> Nothing
      | otherwise = minimumByMaybe [case distMatrix Data.Array.! (current, next) of
                                     Just d -> addDistance next d <$> memoTable Data.Array.! (next, visited `Data.Bits.clearBit` next)
                                     Nothing -> Nothing
                                   | next <- [0 .. n - 1], visited `Data.Bits.testBit` next]
      where
        addDistance :: Int -> Distance -> (Distance, Int) -> (Distance, Int)
        addDistance next d (d', _) = (d + d', next)

    -- Function to get the minimum path with Just values only
    minimumByMaybe :: [Maybe (Distance, Int)] -> Maybe (Distance, Int)
    minimumByMaybe xs = case Data.List.filter (/= Nothing) xs of
                          [] -> Nothing
                          js -> Just $ Data.List.minimumBy (\x y -> compare (fst x) (fst y)) (map (\(Just x) -> x) js)

    -- Reconstruct path from memoTable, add start city at the end for return
    reconstructPath :: (Int, Int) -> [Int]
    reconstructPath (start, visited)
      | visited == 0 = [start]
      | otherwise =
          case memoTable Data.Array.! (start, visited) of
              Just (_, next) -> start : reconstructPath (next, visited `Data.Bits.clearBit` next)
              Nothing -> []  -- Return empty if no valid path found

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