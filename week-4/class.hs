data Shape
    = Circle Float Float Float
    | Rectangle Float Float Float Float
    deriving (Show, Eq)

surface :: Shape -> Float
surface (Circle _ _ r) = pi * r ^ 2
surface (Rectangle x1 y1 x2 y2) = (x1 - x2) * (y1 - y2)


data KV k v = KV [(k, v)]

lookup' :: Eq k => KV k v -> k -> Maybe v
lookup' (KV []) _ = Nothing
lookup' (KV ((k, v) : t)) key
 | key == k = Just v
 | otherwise = lookup' (KV t) key

circumference :: Float -> Float
circumference r = 2 * pi * r

-- ламбди
value :: [Integer]
value = map (\(a, b) -> a + b) [(1, 2), (3, 4), (5, 6)]

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

zipped :: [Integer]
zipped = zipWith' (+) [1 .. 30] [30 .. 64]

--  Let's implement vector

data Vector a = Vector a a a deriving (Show, Eq)

addVec :: Num a => Vector a -> Vector a -> Vector a
addVec (Vector x1 y1 z1) (Vector x2 y2 z2) = Vector (x1 + x2) (y1 + y2) (z1 + z2)

data Bool' = True' | False' deriving (Read)

-- read "True'" :: Bool'
-- ✔️

instance Show Bool' where
  show True' = "✔️"
  show False' = "❌"

instance Enum Bool' where
  toEnum n
    | even n = True'
    | otherwise = False'

  fromEnum True' = 0
  fromEnum False' = 1

-- Let's implement our own list

data List a = Empty | Cons a (List a) deriving (Show, Eq)

(<++>) :: List a -> List a -> List a
Empty <++> other = other
(Cons h t) <++> other = Cons h (t <++> other)

catList :: List Integer
catList = Cons 1 . Cons 2 . Cons 3 $ Empty <++> (Cons 4 . Cons 5 $ Empty)

infixr 5 :-:

data List' a = E | a :-: (List' a) deriving (Show, Eq)

list' :: List' Integer
list' = 1 :-: 2 :-: 3 :-: E

-- Record syntax

type Position = (Float, Float)

type Color = String

data Student = Student String String Int String

firstName' :: Student -> String
firstName' (Student firstname _ _ _) = firstname

data Student' = Student'
  { firstName :: String,
    lastName :: String,
    facultyNumber :: Int,
    bio :: String
  }
  deriving (Show)

guy :: Student'
guy =
  Student'
    { firstName = "Haskell",
      lastName = "Curry",
      facultyNumber = 81125,
      bio = "Има 3 програмни езика кръстени на мен"
    }

-- Type constraints

data Map k v = EmptyMap | Map [(k, v)]

type Symbol a = (a, Bool)

data Tree a
  = EmptyTree
  | Node a [Tree a]

words' :: Tree Char
words' = Node 't' [Node 'e' [Node 's' [Node 't' [Node 'a' []]]]]
