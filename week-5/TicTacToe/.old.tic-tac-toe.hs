module Doge.Main where

import Data.List (intersperse, transpose)
import Data.Maybe (isNothing)
import Text.Read (readMaybe)

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

showBoard :: Board -> String
showBoard b =
  concat
    [ intersperse '|' $ concatMap (maybe " " show) r ++ "\n"
      | r <- b
    ]

showGame :: GameState -> String
showGame GameOver {getWinner = winner, getBoard = board} =
  showBoard board
    ++ "Game Over!\n"
    ++ label
  where
    label = case winner of
      Nothing -> "It's a draw"
      Just player -> "Player " ++ show player ++ " won!"
showGame Turn {getPlayer = player, getBoard = board} =
  showBoard board ++ playerLabel
  where
    playerLabel = "Player '" ++ show player ++ "' select your move:"

firstTurn :: GameState
firstTurn =
  Turn
    { getPlayer = First,
      getBoard = replicate 3 $ replicate 3 Nothing
    }

loop :: GameState -> IO ()
loop gs@GameOver {} = putStrLn $ showGame gs
loop gs = do
  putStrLn $ showGame gs
  move <- getLine
  let parsedMove = readMaybe move :: Maybe Position
   in case parsedMove of
        Nothing -> do
          putStrLn "Invalid input, try again"
          loop gs
        Just position ->
          case maybeNextGameState gs position of
            Nothing -> do
              putStrLn "Invalid move, try again"
              loop gs
            Just nextGameState -> loop nextGameState

testState :: [[Maybe Player]]
testState = map (map Just) state
  where
    state =
      [ [First, First, Second],
        [Second, First, Second],
        [First, Second, Second]
      ]

main :: IO ()
main = do
  loop firstTurn
