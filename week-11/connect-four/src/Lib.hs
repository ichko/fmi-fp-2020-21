{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Lib where

import Data.List
import Data.Maybe (isJust, isNothing)
import Utils (maxGridConsecutiveOf, updateAt2DPos)
import Prelude hiding (pure)

type Error = String

data Player
  = First
  | Second
  deriving (Eq)

instance Show Player where
  show First = "o"
  show Second = "x"

nextPlayer :: Player -> Player
nextPlayer First = Second
nextPlayer Second = First

-- think of the matrix as being transposed (rows are vertical)
type Board = [[Maybe Player]]

newtype Move = Move Int

data GameState
  = GameOver (Maybe Player)
  | Running Player

data Game = Game
  { state :: GameState,
    board :: Board
  }

renderMaybePlayer :: Maybe Player -> String
renderMaybePlayer Nothing = " "
renderMaybePlayer (Just player) = show player

renderBoard :: Board -> String
renderBoard board =
  ""
    ++ (horizontalRow ++ "\n")
    ++ concatMap ((++ "|\n") . concatMap (('|' :) . renderMaybePlayer)) transposedBoard
    ++ horizontalRow
  where
    transposedBoard = transpose board
    w = length board
    horizontalRow = '+' : replicate (3 * (w - 2) - 1) '-' ++ "+"

render :: Game -> String
render Game {state = GameOver winner, board} =
  renderBoard board ++ "\n" ++ case winner of
    Nothing -> "Game Over\nIt's a draw"
    Just player -> "Game Over\nwinner: [" ++ show player ++ "]"
render Game {state = Running player, board} =
  renderBoard board ++ "\nPlayer " ++ show player ++ " select your move:"

maxInARow :: Integer
maxInARow = 4

maybeWinner :: Board -> Maybe Player
maybeWinner board
  | maxFirst >= maxInARow = Just First
  | maxSecond >= maxInARow = Just Second
  | otherwise = Nothing
  where
    -- TODO: Add support for diagonals
    maxFirst = maxGridConsecutiveOf (Just First) board
    maxSecond = maxGridConsecutiveOf (Just Second) board

updateBoard :: Move -> Player -> Board -> Board
updateBoard (Move move) player board =
  updateAt2DPos (firstEmpty, move - 1) (Just player) board
  where
    selectedRow = board !! (move - 1)
    maybeFirstEmpty = findIndex isJust selectedRow
    firstEmpty = case maybeFirstEmpty of
      Nothing -> length selectedRow - 1
      Just val -> val - 1

isDraw :: Board -> Bool
isDraw = not . any isNothing . concat

isValidMove :: Move -> Game -> Bool
isValidMove (Move move) Game {..} =
  move > 0 && length board >= move && isNothing (head (board !! (move - 1)))

update :: Move -> Game -> Either Error Game
update _ Game {state = GameOver _} = Left "Can't update finished game"
update move game@Game {state = Running player, board = prevBoard}
  | not $ isValidMove move game = Left "Invalid move"
  | isDraw board = gameOver Nothing
  | otherwise = case maybeWinner board of
    Just winner -> gameOver $ Just winner
    Nothing -> Right $ Game {state = Running $ nextPlayer player, board}
  where
    board = updateBoard move player prevBoard
    gameOver maybePlayer = Right $ Game {state = GameOver maybePlayer, board}

initialGame :: Game
initialGame =
  Game
    { state = Running First,
      board = replicate 6 $ replicate 6 Nothing
    }

play :: [Move] -> [String]
play moves = map renderEitherGame gameSequence
  where
    gameSequence = Right initialGame : loop moves initialGame
    loop [] _ = []
    loop (move : rest) game =
      let eitherNextGame = update move game
          lastValidGame = either (const game) id eitherNextGame
       in eitherNextGame : loop rest lastValidGame

renderEitherGame :: Either Error Game -> String
renderEitherGame (Left error) = error
renderEitherGame (Right game) = render game
