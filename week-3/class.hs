type Name = String

type Greeting = String

greet :: Name -> Greeting
greet name = "Hello " ++ name

type Vector a = (a, a, a)

length' :: Floating a => Vector a -> a
length' (x, y, z) = sqrt (x ^ 2 + y ^ 2 + z ^ 2)

factorial :: (Eq p, Num p) => p -> p
factorial 0 = 1
factorial n = factorial $ n - 1

map' :: (t -> a) -> [t] -> [a]
map' _ [] = []
map' f (h : t) = f h : map' f t

f :: Floating c => c -> c -> c
f a b = sin . cos $ a * b

lookup' :: Eq k => [(k, v)] -> k -> v -> v
lookup' mappings key missingValue =
  case mappings of
    [] -> missingValue
    ((k, v) : t) ->
      if k == key
        then v
        else lookup' t key missingValue

scaleVector :: Num a => [a] -> a -> [a]
scaleVector v n =
  case v of
    [] -> []
    (ah : at) -> ah * n : scaleVector at n

-- map, filter

square :: Num a => a -> a
square x = x * x

squares :: [Integer]
squares = map square [1 .. 30]

biggerThan200 :: (Ord a, Num a) => a -> Bool
biggerThan200 x = x > 200

biggerSquares :: [Integer]
biggerSquares = filter biggerThan200 squares

-- Пример за частично прилагане на функции

sum' :: Num a => a -> a -> a -> a
sum' a b c = a + b + c

sum3 :: Integer -> Integer -> Integer
sum3 = sum' 3

sum5 :: Integer -> Integer
sum5 = sum' 3 2

fifteen :: Integer
fifteen = sum5 10

-- Още един пример

takeFirstFive :: [a] -> [a]
takeFirstFive = take 5

firstFive :: [Integer]
firstFive = takeFirstFive [2, 4, 6, 0, 1, 0, 0]

-- squares curry

squares' :: [Integer]
squares' = map (^ 2) [1 .. 30]

biggerSquares' :: [Integer]
biggerSquares' = filter (> 200) squares'

-- функции от по висок ред

type Function a = a -> a

derive :: Fractional a => a -> (a -> a) -> a -> a
derive eps f x = (f (x + eps) - f x) / eps

df :: (Function Double) -> Double -> Double
df = derive 1e-10

integrate :: (Num a, Enum a) => a -> (a, a) -> (a -> a) -> a
integrate eps (a, b) f =
  sum . map ((* eps) . f) $ [a, a + eps .. b]

type Interval a = (a, a)

(~∫) :: (Interval Double) -> (Function Double) -> Double
(~∫) = integrate 1e-3

inf :: Double
inf = 1e3

zero :: Double
zero = 1e-10

pi' :: Double
pi' = 2 * (zero, inf) ~∫ (\x -> (sin x) / x)

-- (0, pi) ~∫ sin
-- 1.999999997939027
-- <https://www.wolframalpha.com/input/?i=integrate+sin+x+dx+from+0+to+pi>

(<++>) :: Num a => a -> a -> a
(<++>) a b = a + b

-- ламбди

value :: [Integer]
value = map (\(a, b) -> a + b) [(1, 2), (3, 4), (5, 6)]

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

zipped = zipWith' (+) [1 .. 30] [30 .. 64]

-- stuff

join :: a -> [a] -> [a]
join _ [] = []
join _ [a] = [a]
join delimiter (h : t) = h : delimiter : join delimiter t

rick :: [([Char], [Char])]
rick = zip (replicate 3 "never gonna ") ["give you up", "let you down", "run around and desert you"]

lyrics :: [Char]
lyrics = concat . join "\n" . map (\(l, r) -> l ++ r) $ rick

main :: IO ()
main = putStrLn lyrics
