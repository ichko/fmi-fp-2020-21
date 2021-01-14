module Main where

import Lib

main :: IO ()
main = do
  putStrLn $ showSudoku sudoku
  print $ getEmptyPos sudoku
  putStrLn . showSudoku . solveStep $ sudoku
  mapM_ putStrLn
    . take 20
    . map ((++ "\n") . showSudoku)
    . solveSudoku
    $ sudoku
