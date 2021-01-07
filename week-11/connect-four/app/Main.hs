module Main where

import Lib

getMove :: IO Move
getMove = do
  move <- getLine
  let intMove = read move :: Int
  return (Move intMove)

loop game = do
  putStrLn $ render game
  move <- getMove

  case update move game of
    Left error -> do
      putStrLn error
      loop game
    Right gameOver@Game {state = GameOver _} ->
      putStrLn $ render gameOver
    Right nextGame -> loop nextGame

main = loop initialGame
