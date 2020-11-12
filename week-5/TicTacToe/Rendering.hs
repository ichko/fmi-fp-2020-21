module Rendering where

import Data.List (intersperse)
import Types (Board, GameState (..), Player (First))

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
