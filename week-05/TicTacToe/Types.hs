module Types where

data Player = First | Second deriving (Eq)

instance Show Player where
  show First = "x"
  show Second = "o"

type Board = [[Maybe Player]]

type Position = (Int, Int)

data GameState = Running | GameOver (Maybe Player)

data Game = Game
  { player :: Player,
    board :: Board,
    state :: GameState
  }
