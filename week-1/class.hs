a = 3

b = 10 * a

-- едноредов коментар

{--
    многоредов коментар
--}

sum' a b =
  a + b

s = 10 `sum'` 3

-- функционален факториел
factorial 0 = 1
factorial n = n * factorial (n - 1)

greet :: [Char] -> String
greet name = "Hello " ++ name

-- не толкова функционално написан факториел
factorial' n =
  if n == 0
    then 1
    else n * factorial' (n - 1)

-- Хаскел документация
-- Как да комплираме файл
