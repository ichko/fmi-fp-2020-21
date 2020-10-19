# Седмица 2 - За типовете (Typeclasses). Pattern matching. Where, Let in, Case.

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

### Типови променливи

- Типопвете променливи placeholder-и за типове. Позволява писането на по-генерични функци.

- Функции с типови променливи се наричат полиморфични.

- Инспектиране на типа на полиморфична функция `:t (==)`.

### Типови класове (typeclasses)

Нещо като интерфейси за типове. Ако определен тип инстанцира определен типов клас
то класът е имплементирал функциите които този типов клас изисква.

- `Eq`
- `Ord`
- `Show`
- `Read`
- `Enum`
- `Num`

### Let in, case of

...

## Задачи

1. Write a program that prints the numbers from 1 to 100. But for multiples of three print “Foo” instead of the number and for the multiples of five print “Bar”. For numbers which are multiples of both three and five print "FooBar".

2. **(\*)** Да се дефинира функция за превръщане на цяло число в стринг.
3. **(\*)** Да се дефинира функция която парсва число от стринг (от `"123"` в `123`).
