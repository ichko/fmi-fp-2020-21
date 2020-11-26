module Lib where

data Player
  = First
  | Second
  deriving (Eq)

type Board = [[Maybe Player]]

newtype Move = Move Int

play :: [Move] -> [String]
play moves = undefined
