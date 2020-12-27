import Solution
import Test.HUnit

evalNonNested :: Test
evalNonNested = TestCase $ do
  assertEqual "1" (Just 1) (eval (Atom 1))
  assertEqual "1+1" (Just 2) (eval $ Add (Atom 1) (Atom 1))
  assertEqual "5-3" (Just 2) (eval $ Subtr (Atom 5) (Atom 3))
  assertEqual "2*2" (Just 4) (eval $ Mul (Atom 2) (Atom 2))
  assertEqual "8/3" (Just 2) (eval $ Div (Atom 8) (Atom 3))
  assertEqual "8/0" Nothing (eval $ Div (Atom 8) (Atom 0))

evalSimpleNested :: Test
evalSimpleNested = TestCase $ do
  assertEqual
    "(1+1)/2*3"
    (Just 3)
    (eval (Mul (Div (Add (Atom 1) (Atom 2)) (Atom 2)) (Atom 3)))
  assertEqual
    "1+4-5*20/3"
    (Just (-25))
    ( eval
        ( Subtr
            (Add (Atom 1) (Atom 4))
            (Mul (Atom 5) (Div (Atom 20) (Atom 3)))
        )
    )

evalSimpleStringBrackets :: Test
evalSimpleStringBrackets = TestCase $ do
  assertEqual "1" (Just 1) (evaluateString "1")
  assertEqual "(1+1)" (Just 2) (evaluateString "(1  +1 )")
  assertEqual
    "((1+1)/(2*3))"
    (Just 0)
    (evaluateString "((1+ 1) /( 2*  3) )  ")
  assertEqual
    "(1+(4-(5*(20/3))))"
    (Just (-25))
    (evaluateString "  (1 +(  4-(5 *  (20 /3) ) )) ")

-- Depending on your solution these
-- tests might take some time to finish
evalComplexStringBrackets :: Test
evalComplexStringBrackets = TestCase $ do
  assertEqual
    "((34+32)-((44/(8+(9*(3+2))))-22))"
    (Just 88)
    (evaluateString "((34+32)-((44/(8+(9*(3+2))))-22))")
  assertEqual
    "((2-(2+(4+(3-2))))/((2+1)*(2-1)))"
    (Just (-2))
    (evaluateString "((2-(2+(4+(3-2))))/((2+1)*(2-1)))")
  assertEqual
    "(1/(2*(4-(2*2)))"
    Nothing
    (evaluateString "(1/(2*(4-(2*2))))")

-- Bonus Tests

evalSimpleStringNoBrackets :: Test
evalSimpleStringNoBrackets = TestCase $ do
  assertEqual "1" (Just 1) (evaluateString "1")
  assertEqual "1+1" (Just 2) (evaluateString "1 +1  ")
  assertEqual "(1+1)/2*3" (Just 0) (evaluateString "(1   +1) /2  *3 ")
  assertEqual "1+4-5*20/3" (Just (-25)) (evaluateString " 1+4- 5*20/ 3")

evalComplexStringNoBrackets :: Test
evalComplexStringNoBrackets = TestCase $ do
  assertEqual
    "(34+32)-44/(8+9*(3+2))-22"
    (Just 44)
    (evaluateString "(34+ 32)-44/ (8+9 * (3 +2) )-  22   ")
  assertEqual
    "(2-(2+4+(3-2)))/(2+1)*(2-1)"
    (Just (-2))
    (evaluateString "(2-(   2+4+(3-2)))/(2+1)*(2-1  )")

tests :: Test
tests =
  TestList
    [ evalNonNested,
      evalSimpleNested,
      evalSimpleStringBrackets,
      evalComplexStringBrackets
      -- Bonus Tests
      -- Uncomment to check if you get the <new_year_bonus_point_🍾>
      -- evalSimpleStringNoBrackets,
      -- evalComplexStringNoBrackets
    ]

main :: IO Counts
main = runTestTT tests
