# Седмица 8 - Функтори, Моноиди, Монади, Error handling

![](https://adit.io/imgs/functors/value_and_context.png)

**[Functors, Applicatives, And Monads In Pictures](https://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)** - много готин ресурс

## Материал

### Какво правихме предния път

### Монада

- трансформация на "нещо" в "тип кутийка"
- подаващия трансформацията знае, че работи в контекста на монадата
- интерфейс

  - `return :: Monad m => a -> m a` - позволява ни да затвори стойност в кутийката
  - `(>>=) :: Monad m => m a -> (a -> m b) -> m b`
    позволява ни да направим трансформация в контекста на монадата - взимаме стойността от кутийката и връщаме нова кутийка

- Пример
  ```hs
  Just 5 >>= \a -> Just (a + 3)
  Just 8
  ```

## Задачи

1. Имплементирайте `JSON parser`
   - `Null` - `"null"`
   - `Bool` - "True", "False"
   - `Integer` - "1", "2", "43432", "-43"
     - няма да поддържа `floats`
   - `String` - не е нужно да поддържате escape-нати стрингове
   - `Array`
   - `Object`
