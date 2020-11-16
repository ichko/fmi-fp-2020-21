module Main where

import Logic (maybeUpdateGame)
import Rendering (firstTurn, showGame)
import Text.Read (readMaybe)
import Types
  ( Game (Game, state),
    GameState (GameOver),
    Player (..),
    Position,
  )

loop :: Game -> IO ()
loop g@Game {state = GameOver _} = putStrLn $ showGame g
loop gs = do
  putStrLn $ showGame gs
  move <- getLine
  let parsedMove = readMaybe move :: Maybe Position
   in case parsedMove of
        Nothing -> do
          putStrLn "Invalid input, try again"
          loop gs
        Just position ->
          case maybeUpdateGame gs position of
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
