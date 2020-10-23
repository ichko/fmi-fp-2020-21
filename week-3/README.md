# Седмица 3 - Функции от по висок ред. Currying. Ламбда функции. Map, filter. Всякакви видове fold. Извикване на ф-я с \$. Композиция на функции.

## Материал

### Какво правихме предния път

...

### Компилиране на хаскел файл

```hs
-- file.hs
main = putStr "Hello world!"

> ghci file.hs
```

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

...

## Задачи

1. ...
2. ...
