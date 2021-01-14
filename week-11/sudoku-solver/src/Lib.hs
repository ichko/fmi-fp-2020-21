module Lib where

import Data.List
import Data.List.Split

someFunc :: IO ()
someFunc = putStrLn "someFunc"

emptyValue :: CellValue
emptyValue = 0

type Position = (Int, Int)

type CellValue = Integer

newtype Sudoku = Sudoku [CellValue]
  deriving (Show, Eq)

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

getEmptyPos :: Sudoku -> [Position]
getEmptyPos (Sudoku list) = (\a -> (a `mod` 9, a `div` 9)) <$> posInList
  where
    posInList = indexesOf emptyValue list

indexesOf :: Eq a => a -> [a] -> [Int]
indexesOf v = map fst . filter ((== v) . snd) . zip [0 ..]

updateList :: Int -> a -> [a] -> [a]
updateList pos value list =
  take pos list ++ [value] ++ drop (pos + 1) list

updateSudoku :: Position -> CellValue -> Sudoku -> Sudoku
updateSudoku (x, y) value (Sudoku list) =
  Sudoku $ updateList pos value list
  where
    pos = y * 9 + x

solveStep :: Sudoku -> Sudoku
solveStep s = case clue of
  Nothing -> s
  Just (pos, [value]) -> updateSudoku pos value s
  where
    clue =
      find ((== 1) . length . snd)
        . map (\p -> (p, getPossibleNumbers p s))
        $ getEmptyPos s

solveSudoku :: Sudoku -> [Sudoku]
solveSudoku s =
  if s == newSudoku
    then []
    else s : solveSudoku newSudoku
  where
    newSudoku = solveStep s
