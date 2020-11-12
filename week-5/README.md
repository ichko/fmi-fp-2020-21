# Седмица 5 - Ламбда функции. За типовете (Typeclasses)

<!-- TODO -->

## Материал

### Какво правихме предния път

- Lambda functions - функции без имена които няма да преизползваме
- Алгебрични типове - Множества от стойности получени чрез обединение и сечение.
  - Синтаксис `data Type' = Value1 String String | Value2 Float`
  - Четем тип `Type'` може да има стойност `Value1` или `Value2`
  - `Value1` и `Value2` може да обединяват поредица от стойности.
- Можем да имаме рекурсивно дефинирани типове - Пример: `[]`
- Typeclasses - "интерфейси".
  - `Eq`, `Ord`, `Num`, etc.

### Не остана време за

### Двоично дърво

```hs
data Tree a = Empty | Tree a (Tree a) (Tree a) deriving (Show)
```

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

## Модули

> A Haskell module is a collection of related functions, types and typeclasses.

## Задачи
<!-- TODO -->
