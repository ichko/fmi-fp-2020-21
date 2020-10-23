import System.Environment

toBinary :: (Integral a, Show a) => a -> [Char]
toBinary 0 = "0"
toBinary n = toBinary (n `div` 2) ++ (show (n `mod` 2))

elemIndex :: (Num t1, Eq t2) => t2 -> [t2] -> t1
elemIndex a l = iter a l 0
  where
    iter _ [] _ = -1
    iter a (h : t) idx = if a == h then idx else iter a t (idx + 1)

padZeros :: Int -> [Char] -> [Char]
padZeros cnt str = take pad (repeat '0') ++ str
  where
    pad = max 0 (cnt - length str)

movingWindow :: Int -> [a] -> [[a]]
movingWindow _ [] = []
movingWindow size l@(_ : t) = take size l : movingWindow size t

-- <https://en.wikipedia.org/wiki/Elementary_cellular_automaton>
simulateCellularAutomata :: (Eq t, Num t, Integral a, Show a) => [Char] -> a -> t -> [Char]
simulateCellularAutomata initialState ruleNum its = render (loop initialState) its
  where
    rule = padZeros 8 (toBinary ruleNum)

    nextCellState state rule = rule !! ruleId
      where
        ruleId = elemIndex state ["111", "110", "101", "100", "011", "010", "001", "000"]

    getCellStates state = init $ init $ movingWindow 3 state

    nextGridState state =
      [ nextCellState cell rule
        | cell <- getCellStates ('0' : state ++ "0")
      ]

    loop state = state : loop (nextGridState state)

    render (state : loop) its
      | its == 0 = []
      | otherwise = mapStateToStr state ++ render loop (its - 1)
      where
        cmap '0' = "  "
        cmap '1' = "##"

        mapStateToStr state = concat [cmap c | c <- state] ++ ['\n']

printExampleCA :: (Integral a, Show a, Num t, Eq t) => a -> t -> IO ()
printExampleCA numRule its =
  putStr $ simulateCellularAutomata state numRule its
  where
    zeroPadding = 40
    state = replicate zeroPadding '0' ++ "1" ++ replicate zeroPadding '0'

serpinski :: IO ()
serpinski = printExampleCA 90 30

rule110 :: IO ()
rule110 = printExampleCA 110 30

-- read rule and iterations from stdin
main :: IO ()
main = do
  args <- getArgs
  let (numRule : its : []) = [read a :: Int | a <- args]
  printExampleCA numRule its
