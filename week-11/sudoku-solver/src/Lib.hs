module Lib where

import Data.List
import Data.List.Split
import Test.Hspec

someFunc :: IO ()
someFunc = putStrLn "someFunc"

emptyValue :: CellValue
emptyValue = 0

type Position = (Int, Int)

type CellValue = Integer

newtype Sudoku = Sudoku [CellValue] deriving (Show)

readSudoku :: String -> Sudoku
readSudoku = Sudoku . map charToCell
  where
    charToCell '.' = emptyValue
    charToCell digit = read [digit]

sudokuString :: String
sudokuString =
  "5...8..49...5...3..673....115..........2.8..........187....415..3...2...49..5...3"

sudoku :: Sudoku
sudoku = readSudoku sudokuString

showSudoku :: Sudoku -> String
showSudoku (Sudoku list) =
  intercalate "\n" . map (concatMap $ (++ " ") . mapDigit) $ chunksOf 9 list
  where
    mapDigit 0 = "."
    mapDigit a = show a

getPositionRow :: Position -> Sudoku -> [CellValue]
getPositionRow (_, y) (Sudoku list) = chunksOf 9 list !! y

getPositionCol :: Position -> Sudoku -> [CellValue]
getPositionCol (x, _) (Sudoku list) = map (!! x) . chunksOf 9 $ list

getPositionSquare :: Position -> Sudoku -> [CellValue]
getPositionSquare (x, y) s@(Sudoku list) = firstRow ++ secondRow ++ thirdRow
  where
    (x', y') = (3 * (x `div` 3), 3 * (y `div` 3))

    firstRow = take 3 . drop x' $ getPositionRow (-1, y') s
    secondRow = take 3 . drop x' $ getPositionRow (-1, y' + 1) s
    thirdRow = take 3 . drop x' $ getPositionRow (-1, y' + 1) s

getPossibleNumbers :: Position -> Sudoku -> [CellValue]
getPossibleNumbers pos s = [1 .. 9] \\ impossible
  where
    impossible = nub . filter (/= 0) $ row ++ col ++ square
    row = getPositionRow pos s
    col = getPositionCol pos s
    square = getPositionSquare pos s

getEmptyPos :: Sudoku -> Maybe Position
getEmptyPos (Sudoku list) = (\a -> (a `div` 3, a `mod` 3)) <$> posInList
  where
    posInList = elemIndex emptyValue list

solveStep :: Sudoku -> Sudoku
solveStep = undefined
