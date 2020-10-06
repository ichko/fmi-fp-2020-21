# Седмица 1 - Функционален стил. Интро в Хаскел.

![The problem with Haskell is that it's a language built on lazy evaluation and nobody's actually called for it.](https://imgs.xkcd.com/comics/haskell.png)

## Материал

- Първи час.

  - Какво характеризира функционалният стил.
  - Чисти функции.
  - Мързеливост в Xаскел.
  - Статични типове.
  - Подкарване на код:

    - VSCode plugins
    - [Haskelly](https://github.com/haskelly-dev/Haskelly)
    - [vscode-haskell](https://github.com/haskell/vscode-haskell)
    - [GHCi](https://www.haskell.org/ghc/download.html)
    - [Haskell Platform](https://www.haskell.org/platform/)

    ```sh
    sudo apt-get install haskell-platform
    ...
    ghci
    ```

    - baby.hs

      - `:l baby`
      - `:r`

    - Аритметични операции. - `+`, `-`, `*`, `/`. Умножене по отрицателно число - заграждаме в скоби - `420 * (-69)`
    - Булеви операции - `&&`, `||`, `not`.
    - Равенство - `==`, `/=`.
    - Бинарни функции - инфиксен синтаксис.
    - `div 24601 336` vs `` 24601 `div` 337 ``
    - Още функции - `pred`, `succ`, `min`, `max`. Пример - `succ 9 + max 5 4 + 1 `

    - Изрази - всяка конструкция връща резултат.
    - if-then-else

    ```hs
    a = 3
    b = 4
    if a > b then 88 else 66
    > 66
    ```

    - Дефиниране на функции

    ```hs
    <име> [параметър] = <израз>
    ```

    - Пример

    ```hs
    isPythagoreanTriple a b c = a ^ 2 + b ^ 2 == c ** 2
    ```

    - Извикване на функция

- Втори час

  - Листи

    - Синтаксис - `[1,2,3]`
    - Хомогенни
    - `head`, `tail`, `last`, `init` - нарисувай диаграма
    - Добавяне в лист
      - `5:[1,2,3]`
      - Добавяне отзад - `[1,2,3] ++ [5]` (линейна операция)
      - `[1,2,3]` е синтактична захар за `1:2:3[]`
      - `'A':" SMALL CAT"`
    - `[]`, `[[]]` и `[[],[],[]]`
    - Конкатенация - `++`
    - Индексиране - `!!` (линейна операция)
      - `[1,2,3] !! 2 == 3`
    - Още вградени функции - `length`, `null`, `take`, `drop`, `sum`, `product`, `maximum`, `minimum`, `elem`.
      - `` 6 `elem` [4,5,6,7] ``
    - List ranges

      - `[1..10]` == `[1,2,3,4,5,6,7,8,9,10]`
      - `[5,10..100]`
      - `['a'..'z']`
      - `['K'..'Z']`
      - В обратна посока - `[20,19..1]`
      - Floating point числата са малко шейди в list ranges

        ```hs
          ghci> [0.1, 0.3 .. 1]
          [0.1,0.3,0.5,0.7,0.8999999999999999,1.0999999999999999]
        ```

      - Не можем да правим неща от сорта на - `[1,2,4,8,16..100]` и да очакваме всички степени на 2ката (демек само аритметични прогресии).

    - Сравняване на листи - ако нещата в тях са сравними
      - `[1,2,3] > [2,3,4]`
      - `[[1], [2,3]] < [[3]]`
      - `[1,2] == [1,2]`
    - Безкрайни листи

      - Просто не спецфицираме горна граница
      - Всички естествени числа `[1..]`
        - `Ctl + c` за да спрем принтването
      - `take 10 [1..]`
      - `[40, 50 ..]`
      - `take 100 [10,0..]`

    - `cycle` & `repeat`

      - `take 15 (cycle "NA ") ++ "Batman!"`
      - `take 100 (repeat 'A')`

    - List comprehensions

      - [Set-builder notation](https://en.wikipedia.org/wiki/Set-builder_notation)

        ![Пример](https://wikimedia.org/api/rest_v1/media/math/render/svg/e6eafa5de185b3eeaab95c7ab27422b0b4d03e44)

        ![Анотиран пример](https://wikimedia.org/api/rest_v1/media/math/render/svg/611bbc7dd2005e4d52e287cdbf66cfb90782ccdb)

      - Еквивалентен пример на Хаскел
        ```hs
        > let s = [ 2*x | x <- [0..], x^2 > 3 ]
        > take 10 s
        [4,6,8,10,12,14,16,18,20,22]
        ```
      - Няколко предиката
      - Декартово произведение

## Примери

```hs

```

## Задачи
