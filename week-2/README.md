# Седмица 2 - За типовете (Typeclasses). Pattern matching. Where, Let in, Case.

![Клетъчен автомат - правило 110](../assets/110.png)

## Материал

### Throwback

- Листи
  - Добавяне - отпред, отзад, Конкатенация, Индексиране
  - List ranges
  - List comprehensions

### Неща за които не остана време

- Деструкториране на лист - `head`, `tail`, `last`, `init`

- Кортежи (tuples)
  - Като лист, ама с определена дължина, която предварително знаем.
  - Може да съдържа стойности на данни от различни типове.
  - Типът на кортежа се определя от типовете на данните в него (в реда в който се срещат).
  - Пример - вектор
  - Пример - асоциативен списък - име/факултетен номер.
  - `fst`, `snd`
    - Как можем да си ги имплементираме?

### Pattern matching с листи и кортежи

Идея - пишем различни имплементации в зависимост от "формата" на входа.

- Мачване на прости форми
- Мачване на листи - празен лист `[]` vs `(глава : опашка)`
- Мачване на кортежи
  - Имплеметиране на `fst`, `snd`
  - Вектор, наредена 2ка - `addVec`

#### Гардове, къде?

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

### Дефиниране на типове

...

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

### Let in, case of

`Let <дефинираме порменливи> in <резултатен израз, който вижда променливите>`,
като `where`, ама локално.

Пример - нормализиране на вектор:

```hs
vecLen :: Floating a => (a, a) -> a
vecLen (x, y) = sqrt (x * x + y * y)

normalized :: Floating b => (b, b) -> (b, b)
normalized v@(x, y) = let l = vecLen v in (x / l, y / l)
```

## Задачи

1. Write a program that prints the numbers from 1 to 100. But for multiples of three print “Foo” instead of the number and for the multiples of five print “Bar”. For numbers which are multiples of both three and five print "FooBar".
2. Напишете ф-я което транспонира матрица.

   ```hs
   transpose [[1,2,3], [4,5,6]] == [[1,4], [2,5], [3,6]]
   ```

3. Да се дефинира функция за превръщане на цяло число в стринг.
4. Да се дефинира функция която парсва число от стринг (от `"123"` в `123`).
