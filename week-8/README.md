# Седмица 8 - Функтор, апликатив, монада и още

![](https://adit.io/imgs/functors/value_and_context.png)

**[Functors, Applicatives, And Monads In Pictures](https://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)** - много готин ресурс

## Материал

### Какво правихме предния път

- Довършихме разни неща за `IO`
- Решавахме задача заедно

### Разни абстрактни типове

#### [Semigroup](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Semigroup.html)

> A type a is a `Semigroup` if it provides an associative function `(<>)` that lets you combine any two values of type a into one. Where being associative means that the following must always hold:

```hs
(a <> b) <> c == a <> (b <> c)
```

Пример:

```hs
[1,2,3] <> [4,5,6]

*Main> Just "213" <> Just "456"
Just "213456"
```

#### [Monoid](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Monoid.html)

> A Monoid is a Semigroup with the added requirement of a neutral element.

```hs
import Data.Semigroup

mempty :: [Int]
[]

product = getSum $ Sum 2 <> Sum 4
one = getProduct  $ mconcat ([] :: [Sum Int])

product = getProduct $ Product 1 <> Product 4
one = getProduct  $ mconcat ([] :: [Product Int])

mempty :: Product Int
Product {getProduct = 1}
```

#### [Functor](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Functor.html)

```hs
fmap id == id
fmap (f . g) == fmap f . fmap g
```

> A type f is a Functor if it provides a function fmap which, given any types a and b, lets you apply any function of type (a -> b) to turn an f a into an f b, preserving the structure of f.

Тип кутийка който ни дава възможност да трансформираме стойността в "кутийката".

```hs
fmap (+1) $ Just 1
Just 2

fmap (+1) $ Nothing
Nothing

-- Give example with either

-- <$> == fmap
(+1) <$> [1,2,3]
```

#### [Applicative](https://hackage.haskell.org/package/base-4.14.0.0/docs/Control-Applicative.html)

**Дефиниция** - Функтор, който имплементира `(<*>)`

- Този оператор взима трансформация в кутийка отляво, стойност в кутийка отдясно
  и връща кутийка с трансформирана стойност.

```hs
Just (+1) <*> Just 1
Just 2

Nothing <*> Just 1
Nothing

Just (+1) <*> Nothing
Nothing
```

**Whats the point?** - ако нещо се обърка в процеса директно колапсваме в `Nothnig`,
вместо да гръменм.

```hs
Right (+1) <*> Right 1
Right 2

Left "boom" <*> Right 1
Left "boom"

Right (+1) <*> Left "boom"
Left "boom"
```

Също така, може да правим такива неща:

```hs
sum3 a b c = a + b + c

sum3 <$> Just 1 <*> Just 2 <*> Just 3
Just 6

(,,,) <$> Right 1 <*> Right 2 <*> Right 3 <*> Right 4
Right (1,2,3,4)

sequenceA $ Just <$> [1..10]
Just [1,2,3,4,5,6,7,8,9,10]
```

### [Monad](https://hackage.haskell.org/package/base-4.14.0.0/docs/Control-Monad.html)

Applicative с байнд оператор (>>=)

- трансформация на "нещо" в "тип кутийка"
- подаващия трансформацията знае, че работи в контекста на монадата
- интерфейс

  - `return :: Monad m => a -> m a` - позволява ни да затвори стойност в кутийката
  - `(>>=) :: Monad m => m a -> (a -> m b) -> m b`
    позволява ни да направим трансформация в контекста на монадата - взимаме стойността от кутийката и връщаме нова кутийка

```hs
Just 5 >>= \a -> Just (a + 3)
Just 8
```

**Монадите са нещата които работят в `do` блок**

#### Да си имплементираме парсър и да мотивираме повечето от тези абстракции

**Тук имплементираме парсър за ~1час**

Разгледай `Parser.hs` и `tree-parser.hs`.

## Задачи

**🌟 Това е и `бонус задача` - събмитни решение [тук](https://github.com/ichko/fmi-fp-2020-21/issues/9)**

1. Имплементирайте `JSON parser`

   - Може да използвате кода от `Parser.hs`
   - Разгледайте ресурсите в `json-parser.hs` (от тях съм `крал`)
   - Типове
     - `Null` - `null`
     - `Bool` - `true`, `false`
     - `Integer` - `1`, `2`, `43432`, `-43`
       - няма да поддържа `floats`
     - `String` - `"ala-bala"`, `"Жълтата дюля беше щастлива, че пухът, който цъфна, замръзна като гьон."`
       - не е нужно да поддържате escape-нати стрингове
     - `Array` - `[1,2, false, true, "test", [1,2,[]]]`, `[]`
     - `Object` - `{}`, `{"a":false, "true": 4, "b": {t: [1, 2, false, []]}}`

2. Напишете unit тестове за парсъра си
   - Не забравяйте да валидирате, че гърми правилно и когато трябва
