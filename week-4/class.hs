-- ламбди

value :: [Integer]
value = map (\(a, b) -> a + b) [(1, 2), (3, 4), (5, 6)]

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

zipped :: [Integer]
zipped = zipWith' (+) [1 .. 30] [30 .. 64]
