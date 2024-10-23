import qualified Data.List
import qualified Data.Array
import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String
type Path = [City]
type Distance = Int

type RoadMap = [(City,City,Distance)]    --type for the graphs used as input of all the functions to be implemented


-- Auxiliary function to remove duplicate cities
rmd :: Eq a => [a] -> [a]
rmd [] = []
rmd (x: xs) = x : rmd (filter(/= x) xs)

-- [City], returns all the cities in the graph 
cities :: RoadMap -> [City]
cities [] = []
cities ((c1, c2, _): xs) = rmd(c1 : c2 : cities xs)
 
-- returns a boolean indicating whether two cities are linked directly
areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent [] c1 c2 = False
areAdjacent ((city1,city2,_):xs) c1 c2
    | ((city1==c1 && city2==c2)||(city1==c2 && city2==c1)) = True
    | otherwise = areAdjacent xs c1 c2



-- returns a Just value with the distance between two cities connected directly, given two city names, and Nothing otherwise
distance :: RoadMap -> City -> City -> Maybe Distance
distance [] c1 c2 = Nothing
distance ((c1,c2,d) : xs) city1 city2
    | (city1 == c1 && city2 == c2) || (city1 == c2 && city2 == c1) = Just d
    | otherwise = distance xs city1 city2


-- returns the cities adjacent to a particular city (that is cities with a direct edge between them) and the respective distance to them
adjacent :: RoadMap -> City -> [(City,Distance)]
adjacent = undefined

-- returns the sum of all individual distances in a path between two cities in a Just value, if all the consecutive pairs of cities are directly connected by roads. Otherwise it returns Nothing
pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance = undefined


-- returns the names of the cities with the highest number of roads connecting to them (vertices with the highest degree)
rome :: RoadMap -> [City]
rome = undefined


-- returns a boolean indicating whether all the cities in the graph are connected in the roadmap (if every city is reachable from every other city)
isStronglyConnected :: RoadMap -> Bool
isStronglyConnected = undefined



shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath = undefined

travelSales :: RoadMap -> Path
travelSales = undefined

tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function



-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7","6",1),("8","2",2),("6","5",2),("0","1",4),("2","5",4),("8","6",6),("2","3",7),("7","8",7),("0","7",8),("1","2",8),("3","4",9),("5","4",10),("1","7",11),("3","5",14)]

gTest2 :: RoadMap
gTest2 = [("0","1",10),("0","2",15),("0","3",20),("1","2",35),("1","3",25),("2","3",30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0","1",4),("2","3",2)]


-- Test the cities function
main = do
    print $ cities gTest1  -- Expected: List of all cities in gTest1 without duplicates
    print $ cities gTest2  -- Expected: List of cities in gTest2
    print $ cities gTest3  -- Expected: List of cities in gTest3
