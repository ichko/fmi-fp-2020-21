lookup' :: Eq k => [(k, v)] -> k -> v -> v
lookup' mappings key missingValue =
  case mappings of
    [] -> missingValue
    ((k, v) : t) ->
      if k == key
        then v
        else lookup' t key missingValue

lSystem :: Eq a => [a] -> [(a, [a])] -> [[a]]
lSystem axiom rules = loop axiom
  where
    nextCharState char = lookup' rules char [char]

    getNextState state = concat [nextCharState char | char <- state]

    loop state = state : loop (getNextState state)

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (h : t) =
  let sm = quicksort $ filter (<= h) t
      bg = quicksort $ filter (> h) t
   in sm ++ [h] ++ bg

collatz :: Integral a => a -> [a]
collatz 1 = [1]
collatz n = n : collatz m
  where
    m = if even n then n `div` 2 else 3 * n + 1

type Function a = a -> a

derive :: Fractional a => a -> (a -> a) -> a -> a
derive eps f x = (f (x + eps) - f x) / eps

df :: (Function Double) -> Double -> Double
df = derive 1e-10

newton'sMethod :: (Eq t, Num t) => t -> Double -> (Function Double) -> Double
newton'sMethod its x0 f = loop its x0
  where
    nextStep xn = xn - (f xn / df f xn)

    loop 0 x = x
    loop its x = loop (its - 1) $ nextStep x
