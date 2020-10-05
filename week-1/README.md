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

## Примери

## Задачи
