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
  - Синтаксис. Тип на кортеж. Кортежи в листи.
  - `fst`, `snd`

### Типове

`:t` инспектиране на тип в `GHCi`.

Експлицитно задаване на тип - `::`

Често срещани типове:

- `Int`
- `Integer`
- `Float`
- `Double`
- `Bool`
- `Char`

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

### Гардове, къде?

...

### Let in, case of

...

## Задачи

1. Write a program that prints the numbers from 1 to 100. But for multiples of three print “Foo” instead of the number and for the multiples of five print “Bar”. For numbers which are multiples of both three and five print "FooBar".

2. **(\*)** Да се дефинира функция за превръщане на цяло число в стринг.
3. **(\*)** Да се дефинира функция която парсва число от стринг (от `"123"` в `123`).
