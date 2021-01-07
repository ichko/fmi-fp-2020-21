{-# LANGUAGE DeriveFunctor #-}

module Utils where

import Data.Function (on)
import Data.List
  ( genericLength,
    groupBy,
    maximumBy,
    transpose,
  )

newtype State a = State a deriving (Show, Eq, Functor)

instance Applicative State where
  pure a = State a
  (State op) <*> (State val) = pure $ op val

instance Monad State where
  (State s) >>= f = f s

maximumByKey :: Ord b => (a -> b) -> [a] -> Maybe (a, b)
maximumByKey _ [] = Nothing
maximumByKey keyMap list = Just maxed
  where
    mapped = map (\e -> (e, keyMap e)) list
    maxed = maximumBy (compare `on` snd) mapped

maxRowConsecutiveOf :: (Eq a, Ord p, Num p) => a -> [a] -> p
maxRowConsecutiveOf _ [] = 0
maxRowConsecutiveOf el list =
  maybe 0 snd lengths
  where
    groupConsecutive = groupBy ((&&) `on` (== el)) list
    onlyElGroups = filter ((== el) . head) groupConsecutive
    lengths = maximumByKey genericLength onlyElGroups

maxGridConsecutiveOf :: (Ord a1, Num a1, Eq a2) => a2 -> [[a2]] -> a1
maxGridConsecutiveOf el grid = max maxRow maxCol
  where
    maxRow = maximum $ map (maxRowConsecutiveOf el) grid
    maxCol = maximum $ map (maxRowConsecutiveOf el) (transpose grid)

updateAtPos :: Int -> a -> [a] -> [a]
updateAtPos pos val list = take pos list ++ [val] ++ drop (pos + 1) list

updateAt2DPos :: (Int, Int) -> a -> [[a]] -> [[a]]
updateAt2DPos (x, y) val list = updateAtPos y newList list
  where
    newList = updateAtPos x val (list !! y)
