import AssertExpectedScreen (assertExpectedScreen)
import Lib (Move (..), play)
import Test.HUnit
  ( Counts,
    Test (..),
    runTestTT,
  )

testTrivialGames :: Test
testTrivialGames = TestCase $ do
  assertExpectedScreen "no moves game" $ last $ play []
  assertExpectedScreen "one move game" $ last $ play [Move 1]
  -- Game after invalid moves
  assertExpectedScreen "one move game" $
    last $ play [Move (-1), Move 99, Move 1]
  assertExpectedScreen "few moves game" $ last $ play (map Move [1, 2, 2])

testComplexUnfinishedGame = TestCase $ do
  let moves = [1, 2, 2, 3, 3, 3, 4, 4, 5, 4, 6, 6, 6, 1, 4, 4, 4]
  assertExpectedScreen "complex unfinished game" $ last $ play (map Move moves)

testSimpleFinishedGames = TestCase $ do
  assertExpectedScreen "simple vertical finished game" $
    last $ play (map Move [2, 6, 2, 6, 2, 6, 2])
  assertExpectedScreen "simple diagonal finished game" $
    last $ play (map Move [1, 2, 2, 3, 3, 4, 4, 1, 3, 6, 4, 6, 4])
  assertExpectedScreen "simple horizontal finished game" $
    last $ play (map Move [1, 2, 3, 4, 5, 1, 5, 2, 5, 3, 6, 4])

testDrawGames = TestCase $ do
  assertExpectedScreen "draw game" $
    last . play . map Move . concat $
      [ [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6],
        [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1],
        [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6]
      ]

testInvalidGames = TestCase $ do
  assertExpectedScreen "invalid move" $ last $ play $ map Move [0]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [1, 2, 2, -1]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [1, 2, 2, 99]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [7]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [7, 8]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [1, - 99]
  assertExpectedScreen "invalid move" $ last $ play $ map Move [1, - 99]
  -- try to spill the board
  assertExpectedScreen "invalid move" $
    last $ play $ map Move [1, 1, 1, 1, 1, 1, 1]

tryToPlayAfterGameOver = TestCase $ do
  assertExpectedScreen "game over move" $
    last $ play $ map Move [2, 6, 2, 6, 2, 6, 2, 1]
  assertExpectedScreen "game over move" $
    last $ play $ map Move [2, 6, 2, 6, 2, 6, 2, -1]

tests :: Test
tests =
  TestList
    [ testTrivialGames,
      testComplexUnfinishedGame,
      testSimpleFinishedGames,
      testDrawGames,
      testInvalidGames,
      tryToPlayAfterGameOver
    ]

main :: IO Counts
main = runTestTT tests
