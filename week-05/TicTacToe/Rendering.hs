{-# LANGUAGE NamedFieldPuns #-}

module Rendering where

import Data.List (intersperse)
import Types
  ( Board,
    Game (..),
    GameState (GameOver, Running),
    Player (First),
  )

showBoard :: Board -> String
showBoard b =
  concat
    [ intersperse '|' $ concatMap (maybe " " show) r ++ "\n"
      | r <- b
    ]

showGame Game {board, state = GameOver winner} =
  showBoard board
    ++ "Game Over!\n"
    ++ label
  where
    label = case winner of
      Nothing -> "It's a draw"
      Just player -> "Player " ++ show player ++ " won!"
showGame Game {player, board} =
  showBoard board ++ playerLabel
  where
    playerLabel = "Player '" ++ show player ++ "' select your move:"

firstTurn :: Game
firstTurn =
  Game
    { player = First,
      board = replicate 3 $ replicate 3 Nothing,
      state = Running
    }
