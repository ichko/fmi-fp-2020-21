import System.Environment

recipe "luck" = 10
recipe "skill" = 20
recipe "concentrated power of will" = 15
recipe "pleasure" = 5
recipe "pain" = 50
recipe _ = 0

a 0 = 0
a 1 = 1
a n = (a (n - 1) + a (n - 2)) / 2

fib n =
  iter 0 1 n
  where
    iter a _ 0 = a
    iter a b cnt = iter b (a + b) (cnt - 1)

sum' [] = 0
sum' (h : t) = h + sum' t

reverse' [] = []
reverse' (h : t) = reverse t ++ [h]

cat [] b = b
cat (ah : at) b = ah : cat at b

elem' _ [] = False
elem' a (h : t) = a == h || a `elem'` t

-- elem 10000000 [1..]
-- vs
-- elem' 10000000 [1..]

elemIndex a l = iter a l 0
  where
    iter _ [] _ = -1
    iter a (h : t) idx = if a == h then idx else iter a t (idx + 1)

movingWindow _ [] = []
movingWindow size l@(_ : t) = take size l : movingWindow size t

fst' (a, _) = a

snd' (_, b) = b

addVec (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

distVec (x1, y1) (x2, y2) = ()

toBinary 0 = "0"
toBinary n = toBinary (n `div` 2) ++ (show (n `mod` 2))

padZeros cnt str = take pad (repeat '0') ++ str
  where
    pad = max 0 (cnt - length str)

-- Пример за `let in`
vecLen :: Floating a => (a, a) -> a
vecLen (x, y) = sqrt (x * x + y * y)

normalized :: Floating b => (b, b) -> (b, b)
normalized v@(x, y) = let l = vecLen v in (x / l, y / l)

-- <https://en.wikipedia.org/wiki/Elementary_cellular_automaton>

elementaryCA initialState ruleNum = loop initialState
  where
    numToRule num = padZeros 8 (toBinary num)

    nextCellState state rule = rule !! ruleId
      where
        ruleId = elemIndex state ["111", "110", "101", "100", "011", "010", "001", "000"]

    getCellStates state = init $ init $ movingWindow 3 state

    nextGridState state ruleNum =
      [ nextCellState cell $ numToRule ruleNum
        | cell <- getCellStates ('0' : state ++ "0")
      ]

    loop state = state : loop nextState
      where
        nextState = nextGridState state ruleNum

renderCA (state : loop) its
  | its == 0 = []
  | otherwise = mapStateToStr state ++ renderCA loop (its - 1)
  where
    cmap '0' = "  "
    cmap '1' = "##"

    mapStateToStr state = concat [cmap c | c <- state] ++ ['\n']

runExampleCA numRule its =
  renderCA (elementaryCA state numRule) its
  where
    state = "000000000000000000000000000000000000000001000000000000000000000000000000000"

main = do
  args <- getArgs
  let (numRule : its : []) = [read a :: Int | a <- args]
  putStr $ runExampleCA numRule its
