{-# LANGUAGE RecordWildCards #-}

module Logic where

import Data.List (transpose)
import Data.Maybe (isNothing)
import Types

isRowWin :: Board -> Player -> Bool
isRowWin b p = any (all (== Just p)) b

isColWin :: Board -> Player -> Bool
isColWin = isRowWin . transpose

isWinState :: Board -> Player -> Bool
isWinState b p = isRowWin b p || isColWin b p

isValidPosition :: Board -> Position -> Bool
isValidPosition b (x, y) = isNothing $ b !! y !! x

swapListVal :: Int -> a -> [a] -> [a]
swapListVal pos val list =
  take pos list ++ [val] ++ drop (pos + 1) list

nextBoardState :: Board -> Player -> Position -> Board
nextBoardState board player (x, y) =
  swapListVal y updatedRow board
  where
    selectedRow = board !! y
    updatedRow = swapListVal x (Just player) selectedRow

applyMove :: Game -> Position -> Game
applyMove Game {..} position =
  Game
    { player = if player == First then Second else First,
      board = nextBoardState board player position,
      state = state
    }

isBoardFull :: Board -> Bool
isBoardFull = not . any isNothing . concat

maybeUpdateGame :: Game -> Position -> Maybe Game
maybeUpdateGame g@Game {state = GameOver _} _ = Just g
maybeUpdateGame g@Game {..} position
  | not $ isValidPosition board position = Nothing
  | isWinState nextBoard First = gameOver $ Just First
  | isWinState nextBoard Second = gameOver $ Just Second
  | isBoardFull nextBoard = gameOver Nothing
  | otherwise = Just nextGameState
  where
    nextGameState@Game
      { board = nextBoard
      } = applyMove g position

    gameOver maybePlayer =
      Just
        Game
          { player = player,
            board = nextBoard,
            state = GameOver maybePlayer
          }
