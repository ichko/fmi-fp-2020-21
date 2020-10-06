-- task 1
even' :: Integral a => a -> Bool
even' n = n `mod` 2 == 0

-- task 2
factorial :: (Ord p, Num p) => p -> p
factorial n = if n <= 0 then 1 else n * factorial (n - 1)

-- task 3
pow :: (Eq t, Num t, Num p) => p -> t -> p
pow a b = if b == 0 then 1 else a * pow a (b - 1)

-- task 4
fastPow :: (Integral a1, Num a2) => a2 -> a1 -> a2
fastPow x n =
  if n == 0
    then 1
    else
      if even' n
        then fastPow x (n `div` 2) ^ 2
        else x * fastPow x (n - 1)

-- task 5
fib :: (Eq t, Num t, Num p) => t -> p
fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

-- task 6
isPrime :: Integral a => a -> Bool
isPrime n =
  if n == 1
    then False
    else and [n `mod` d /= 0 | d <- [2 .. n - 1]]

-- task 7
gcd' :: Integral t => t -> t -> t
gcd' a b =
  if b == 0
    then a
    else gcd' b (a `mod` b)
