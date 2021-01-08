# Седмица 7 - I/O операции част 2

## Материал

### Какво правихме предния път

- Философствахме над това как да си направим "чисто" IO
  и императивен синтаксис във функционален език.
- Имплементирахме си наше IO като нещо което променя
  тип `World`
- Направихме го да работи с `do`, като доказахме на хаскел, че е монада

### IO Функции

- `putStr`

- `putChar`

  как имплементираме `putStr`, рекурсивно

  ```hs
  putStr :: String -> IO ()
  putStr [] = return ()
  putStr (x:xs) = do
      putChar x
      putStr xs
  ```

- `print = putStrLn . show`

- `when` в `import Control.Monad`

  ```hs
  import Control.Monad

  main = do
      c <- getChar
      when (c /= ' ') $ do
          putChar c
          main
  ```

- `sequence :: [IO a] -> IO [a]` - взима няколко действия, изпълнява ги и ни връща резултатите им.

  ```hs
  main = do
      a <- getLine
      b <- putStr "test"
      print [a,b]

  -- ==

  main = do
    seq = sequence [getLine, putStr "test"]
    print seq
  ```

- `mapM` and `mapM_` - sequence-ва колекция от монади до монада от колекция

  ```hs
  mapM print [1,2,3]
  -- vs
  mapM_ print [1,2,3]
  ```

- `forever` - чейнва IO action със себе си forever

- `forM = flip mapM` - дава ни готин синтаксис

- `getContents` - чете от stdin докато не срещне `end-of-file`

- `interact :: (String -> String) -> IO ()` - чете вход, дава хо на обработващата чиста ф-я и принт-ва резултата.

#### Рабта с файлове

- `readFile :: FilePath -> IO String` - чете

- `writeFile :: FilePath -> String -> IO ()` - пише

### Да решим малко задачи

- [Reverse Polish notation calculator](http://learnyouahaskell.com/functionally-solving-problems#reverse-polish-notation-calculator)

  - [RPN Wikipedia](https://en.wikipedia.org/wiki/Reverse_Polish_notation)

  - Infix expression - `10 4 3 + 2 * -`

  - Как работи?

    > Well, think of a stack. You go over the expression from left to right. Every time a number is encountered, push it on to the stack. When we encounter an operator, take the two numbers that are on top of the stack (we also say that we pop them), use the operator and those two and then push the resulting number back onto the stack. When you reach the end of the expression, you should be left with a single number if the expression was well-formed and that number represents the result.

  - Да прочетем Expression от файл `input` и да запишем резултата във файл `output`.

## Задачи

Асоциативни списъци и графи (откраднати от [тук](https://github.com/ekaranasuf/fp1819/tree/master/week8#%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D0%B8) - мс Еси)

1. Да дефинираме ф-я `mapValues mapper assocList`, която прилага `mapper` в/у всяка стойност на `assocList`.

2. Дефинирайте функция `extendWith assocList1 assocList2`, която връща асоциативен списък, съдържащ всички ключове на `assocList1` и `assocList2`. Ако някой ключ се повтаря, взема този от `assocList2`

3. Дефинирайте базовите функция `vertices graph`, `children graph vertex` и `hasEdge (u, v) graph`

4. Дефинирайте функция `parents graph vertex`, която намира родителите на даден връх в граф

5. Дефинирайте функция `invert graph`, която връща нова граф, получен от `graph` като "обърнем" всички ребра в него

6. Дефинирайте функция `containsPath graph path`, която проверява дали пътят `path` се съдържа в подадения граф

7. Дефинирайте функция `symmetric graph`, която проверява дали дадения граф е симетричен (ако съществува ребро от връх `u` до `v`, то същвстува и ребро от `v` до `u`)
