# Седмица 8 - Функтори, Моноиди, Монади, Error handling

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

1. TODO: (T_T)