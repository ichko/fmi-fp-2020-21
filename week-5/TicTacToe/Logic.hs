module Logic where

import Data.List (transpose)
import Data.Maybe (isNothing)
import Types (Board, GameState (..), Player (..), Position)

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

applyMove :: GameState -> Position -> GameState
applyMove Turn {getBoard = board, getPlayer = player} position =
  Turn
    { getPlayer = if player == First then Second else First,
      getBoard = nextBoardState board player position
    }

isBoardFull :: Board -> Bool
isBoardFull = not . any isNothing . concat

maybeNextGameState :: GameState -> Position -> Maybe GameState
maybeNextGameState g@GameOver {} _ = Just g
maybeNextGameState t@Turn {getBoard = board} position
  | not $ isValidPosition board position = Nothing
  | isWinState nextBoard First = gameOver $ Just First
  | isWinState nextBoard Second = gameOver $ Just Second
  | isBoardFull nextBoard = gameOver Nothing
  | otherwise = Just nextGameState
  where
    nextGameState@Turn
      { getBoard = nextBoard
      } = applyMove t position

    gameOver maybePlayer =
      Just
        GameOver
          { getWinner = maybePlayer,
            getBoard = nextBoard
          }
