# Седмица 4 - Ламбда функции. За типове и класове

![Ray tracer](../assets/rt-hs2.gif)

- [rt.hs](./rt.hs)

## Материал

### Какво правихме предния път

- `map`, `filter`
- `функции от по висок ред` - функция взимаща ф-я като параметър и/или втъщаща функция
- `къри` - частично прилагане
- композиция и прилагане - `.`, `$`

### Не остана време за

- **Ламбда функции** - функции без имена които създаваме на място защото ни трябва само веднъж.

  > We usually surround them by parentheses, because otherwise they extend all the way to the right.

  - Синтаксис `\param1 param2, ... -> <израз>`
  - Не може да се викат рекурсивно.
  - Можем да деструкторираме аргументите както в нормални функции.

  **Примери:**

  ```hs
  map (\x -> x ^ 2 + 3) [1 .. 30]
  ```

  ```hs
  zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
  zipWith' _ [] _ = []
  zipWith' _ _ [] = []
  zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

  zipWith' (+) [1..30] [30..64]
  ```

  **Пример с интериращата функция която написахме предния път**

  ```hs
  inf :: Double
  inf = 1e3

  zero :: Double
  zero = 1e-10

  pi' :: Double
  pi' = 2 * (zero, inf) ~∫ (\x -> (sin x) / x)
  ```

  Проверка - <https://www.wolframalpha.com/input/?i=integrate+sin+x+%2Fx+dx+from+0+to+inf>

### Типове

`:t` инспектиране на тип в `GHCi`.

Експлицитно задаване на тип - `::`

Често срещани типове:

- `Int`
  > Int is bounded, which means that it has a minimum and a maximum value.
  > maximum possible `Int` is `2147483647` and the minimum is `-2147483648`
- `Integer`
  > not bounded so it can be used to represent really really big numbers
- `Float` - single precision

  ```hs
  circumference :: Float -> Float
  circumference r = 2 * pi * r

  ghci> circumference 4.0
  25.132742
  ```

- `Double` - double precision

  ```hs
  circumference' :: Double -> Double
  circumference' r = 2 * pi * r

  ghci> circumference' 4.0
  25.132741228718345
  ```

- `Bool`
- `Char`

> empty tuple `()` is also a type

### Типови променливи

- Типопвете променливи placeholder-и за типове. Позволява писането на по-генерични функци.
- Като темплейтните функции в C++.
- Функции с типови променливи се наричат полиморфични.
- Инспектиране на типа на полиморфична функция `:t (==)`.
  ```hs
  ghci> :t fst
  fst :: (a, b) -> a
  ```

### Типови класове (typeclasses)

Нещо като интерфейси за типове. Ако определен тип инстанцира определен типов клас
то класът е имплементирал функциите които този типов клас изисква.

> Everything before the => symbol is called a class constraint

Да разгледаме `:t elem`.

- `Eq` - `==`, `/=`
- `Ord` - `>`, `<`, `>=`, `<=`, `compare`.
  > The `compare` function takes two `Ord` members of the same type and returns an ordering. `Ordering` is a type that can be `GT`, `LT` or `EQ`.
- `Show` - имат дефинирата ф-я `show`.
- `Read` - имат дефинирана ф-я `read`.
  ```hs
  ghci> read "[1,2,3,4]" :: [Int]
  [1,2,3,4]
  ghci> read "(3, 'a')" :: (Int, Char)
  (3, 'a')
  ```
- `Enum`
  > Enum members are sequentially ordered types — they can be enumerated. The main advantage of the `Enum` typeclass is that we can use its types in list ranges.
  ```hs
  ghci> ['a'..'e']
  "abcde"
  ```
- `Num`

  > `Num` is a numeric typeclass. Its members have the property of being able to act like numbers.

  - `Int`, `Integer`, `Float`, `Double`, са в типовия клас `Num`.
  - `(5 :: Int) * (6 :: Integer)`, ще гръмне.
  - `5 * (6 :: Integer)` ще мине.

- `Integral` - включва `Int` и `Integer`
- `Floating` - включва `Float` и `Double`

- `fromIntegral` е полезна ф-я за работа с ф-ии като `length`, защото `length` връща `Int` по исторически причини, което води до проблеми:
  ```hs
  length [1,2,3,4] + 3.2                -- гърми
  fromIntegral (length [1,2,3,4]) + 3.2 -- не гърми
  ```

### Дефиниране на типове

Типовете - множества от стойности.

#### Алгебрични дата типове

- `data TypeName [typeParam] = [TypeConstructor [typeParam] |]`

  - От дясно на равното стоят типови конструктори - функции които връщат стойности от определен тип.
  - От ляво на равното стои името на типа (+- някой типов параметър)

  ```hs
  data Bool = False | True

  data Shape = Circle Float Float Float | Rectangle Float Float Float Float
  ```

- Да дефинираме ф-я `surface`

- `deriving` синтаксис

  ```hs
  data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)
  ```

#### Рекурсивни типове и типове с параметри

- виж дефиницията на `List'` в упр-то.

- Пример с `BST`
  - Да инсъртваме в него
  - Да търсим в него

#### Record syntax

```hs
data Student' = Student'
  { firstName :: String,
    lastName :: String,
    facultyNumber :: Int,
    bio :: String
  }
  deriving (Show)
```

## Задачи

1. Имплементирайте типа `Vector a a a` и го направете инстанция на `Num`.
2. Да се дефинира ф-я, `multiply a b`, която умножава 2 матрици. (може да приемете, че аргументите, които ще и се подават ще са валидни матрици, които могат да се умножат)
3. Дефинирайте генеричен тип `Histogram a`, който представлява вектор с честоти на елементи от тип `а`.

   - Дефинирайте ф-я `histogram l`, която намира хистограмата на елементите в `l` и връща стойност от тип `Histohram a`.

     Пример:

     ```hs
     histogram ['a', 'b', 'c', 'a', 'a', 'c']
     > Histogram [('a', 3), ('b', 1), ('c', 2)]
     ```

   - Дефинирайте ф-я `plotHistogram h`, която приема елемент от тип `Histogram a` и връща стрингова репрезентация на `bar-chart` на хистограмата. (Ключовете в хистограмата трябва да са `Ord`, и да се сортират по големина)

     Пример:

     ```hs
     h = Histogram [('a', 3), ('b', 1), ('c', 2)]
     plotHistogram h
     > #
       #   #
       # # #
       =====
       a b c
     ```

4. Имплементирайте генерична колекция двоично дърво - `BinTree a`.
5. Имплементирайте ф-я за `insertBST el tree`, която приема елемент и дърво и връща ново дърво, в което елемента е на правилното място спрямо свойството на двоичните дървета за търсене ([Binary Search Trees insertion](https://en.wikipedia.org/wiki/Binary_search_tree#Insertion)).
6. Имплементирайте ф-я `elemBST el tree`, която проверява дали елемент е част от даденото дърво, предполагайки че дървото е двоично дърво за търсене, т.е. изпълнява [BS свойството](https://en.wikipedia.org/wiki/Binary_search_tree#Definition).
7. Докажете че `BinTree` е `showable` по начина показан в примера. По-не-фенси казано - имплементирайте типовия клас `Show` за `BinTree`. (може да предположите че елементите на дървото са едносимволни)

   Пример:

   ```hs
   t = BinTree 1
         (BinTree 2 (BinTree 4 EmptyTree EmptyTree) EmptyTree)
         (BinTree 3
           (BinTree 5 (BinTree 7 EmptyTree EmptyTree) EmptyTree)
           (BinTree 6 EmptyTree EmptyTree))
   print t
   >  1
       |-2
       | |-4
       | | |-x
       | | |-x
       | |-x
       |-3
         |-5
         | |-7
         | | |-x
         | | |-x
         | |-x
         |-6
           |-x
           |-x
   ```
