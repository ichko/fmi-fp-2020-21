-- гардове
-- func arg
--   | <boolean expression> = <нещо>
--   | <boolean expression 2> = <нещо друго>
--   | otherwise = <нещо трето>

isSorted [] = True
isSorted (_ : []) = True
isSorted (a : b : t) = a < b && isSorted (b : t)

sndVec v1 v2 = (fst v1 + fst v2, snd v2 + snd v2)

-- pattern matching на прости типове
recipe "luck" = 10
recipe "skill" = 20
recipe "concentrated power of will" = 15
recipe "pleasure" = 5
recipe "pain" = 50
recipe _ = 0

category m h
  | bmi < 10 = "Хапвай повечко"
  | bmi < 20 = "Екстра си"
  | otherwise = "По-полека с дюнерите"
  where
    bmi = m / h ^ 2

a 0 = 0
a 1 = 1
a n = (a (n - 1) + a (n - 2)) / 2

-- pattern matching във вложена ф-я
fib n =
  iter 0 1 n
  where
    iter a _ 0 = a
    iter a b cnt = iter b (a + b) (cnt - 1)

-- Фибоначи с гард
fibGuard n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fibGuard (n - 1) + fibGuard (n - 2)

-- pattern matching на листи

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

-- pattern matching на кортежи

fst' (a, _) = a

snd' (_, b) = b

addVec (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- пример за let in
distVec (x1, y1) (x2, y2) =
  let dx = x1 - x2
      dy = y1 - y2
   in (dx ^ 2 + dy ^ 2)

-- Пример за `let in`
vecLen :: Floating a => (a, a) -> a
vecLen (x, y) = sqrt (x * x + y * y)

normalized :: Floating b => (b, b) -> (b, b)
normalized v@(x, y) = let l = vecLen v in (x / l, y / l)