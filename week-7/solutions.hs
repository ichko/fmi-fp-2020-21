{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TupleSections #-}

import Data.Maybe (fromMaybe)
import Test.HUnit

type Pair k v = (k, v)

type AssocList k v = [Pair k v]

mapValues :: (v -> mv) -> AssocList k v -> AssocList k mv
mapValues _ [] = []
mapValues mapper ((k, v) : t) = (k, mapper v) : mapValues mapper t

extendWith :: Eq a => AssocList a b -> AssocList a b -> AssocList a b
extendWith [] list = list
extendWith (p@(k, _) : t) list =
  case lookup k list of
    Nothing -> extendWith t (p : list)
    Just _ -> extendWith t list

addOrReplace :: Eq a => Pair a b -> AssocList a b -> AssocList a b
addOrReplace (k, v) assoc = (k, v) : filter ((k /=) . fst) assoc

newtype Graph a = Graph
  { associations :: AssocList a [a]
  }
  deriving (Eq, Show, Functor)

emptyGraph :: Graph a
emptyGraph = Graph {associations = []}

addVertex :: a -> Graph a -> Graph a
addVertex v Graph {..} = Graph {associations = (v, []) : associations}

singleton :: a -> Graph a
singleton a = addVertex a emptyGraph

addEdge :: Eq a => Pair a a -> Graph a -> Graph a
addEdge (a, b) Graph {..} =
  Graph {associations = addOrReplace newAssoc associations}
  where
    newAssoc = maybe (a, [b]) ((a,) . (b :)) $ lookup a associations

fromEdges :: (Eq a) => AssocList a a -> Graph a
fromEdges = foldr addEdge emptyGraph

exampleGraph :: Graph Integer
exampleGraph =
  Graph
    { associations = zip [1 ..] [[2], [1, 3, 4], [3], [1, 3], [6], []]
    }

vertices :: Graph b -> [b]
vertices = map fst . associations

children :: Eq a => a -> Graph a -> [a]
children a Graph {..} = fromMaybe [] $ lookup a associations

hasEdge :: Eq a => Pair a a -> Graph a -> Bool
hasEdge (u, v) g = v `elem` children u g

main :: IO Counts
main = runTestTT $ TestList tests
  where
    graphTests :: [Test]
    graphTests =
      [ TestCase $ do
          assertEqual "no vertices" (vertices (emptyGraph :: Graph Int)) []
          assertEqual "few vertices" (vertices exampleGraph) [1 .. 6],
        TestCase $ do
          assertEqual "no children" (children 6 exampleGraph) []
          assertEqual "one child" (children 1 exampleGraph) [2]
          assertEqual "few children" (children 2 exampleGraph) [1, 3, 4]
          assertEqual "missing vertex" (children 7 exampleGraph) [],
        TestCase $ do
          assertFalse "no edge" (hasEdge (1, 3) exampleGraph)
          assertFalse "no vertex" (hasEdge (0, 1) exampleGraph)
          assertFalse "no vertices" (hasEdge (-1, 0) exampleGraph)
          assertFalse "single vertex" (hasEdge (6, 1) exampleGraph)
          assertTrue "has edge" (hasEdge (1, 2) exampleGraph)
          assertTrue "has edge" (hasEdge (5, 6) exampleGraph)
      ]

    tests :: [Test]
    tests = graphTests

    assertFalse msg val = assertEqual msg val False
    assertTrue msg val = assertEqual msg val True
