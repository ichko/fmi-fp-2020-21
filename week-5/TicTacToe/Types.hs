module Types where

data Player = First | Second deriving (Eq)

instance Show Player where
  show First = "x"
  show Second = "o"

type Board = [[Maybe Player]]

type Position = (Int, Int)

data GameState
  = GameOver
      { getWinner :: Maybe Player,
        getBoard :: Board
      }
  | Turn
      { getPlayer :: Player,
        getBoard :: Board
      }
