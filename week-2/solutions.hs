import Data.Char (ord)

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose [row] = map (: []) row
transpose (row : rest) = zipWith (:) row $ transpose rest

unique :: Eq a => [a] -> [a] -> [a]
unique [] result = result
unique (h : t) result
  | h `elem` result = unique t result
  | otherwise = unique t (h : result)

union :: Eq a => [a] -> [a] -> [a]
union a b = unique (a ++ b) []

intersect :: Eq a => [a] -> [a] -> [a]
intersect [] _ = []
intersect _ [] = []
intersect (h : t) b
  | h `elem` b = h : intersect t b
  | otherwise = intersect t b

-- unsafe extraction from `Maybe`
digitToChar :: (Eq a, Num a, Enum a) => a -> Char
digitToChar digit =
  let (Just v) = lookup digit $ zip [0 .. 9] ['0' .. '9'] in v

charToDigit :: Char -> Int
charToDigit char = ord char - ord '0'

intToString :: Integral t => t -> String
intToString 0 = "0"
intToString n = iter n ""
  where
    iter 0 result = result
    iter n result = iter (n `div` 10) (digitToChar (n `mod` 10) : result)

stringToInt :: String -> Int
stringToInt string = iter string 0
  where
    iter "" result = result
    iter (h : t) result = iter t (10 * result + charToDigit h)

fooBar :: (Integral a, Show a) => a -> String
fooBar n
  | n `mod` 15 == 0 = "FooBar"
  | n `mod` 3 == 0 = "Foo"
  | n `mod` 5 == 0 = "Bar"
  | otherwise = show n

fooBar100 :: String
fooBar100 = concatMap ((++ "\n") . fooBar) [1 .. 100]

main :: IO ()
main = putStrLn fooBar100
