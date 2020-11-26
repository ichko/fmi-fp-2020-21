# Седмица 7 - I/O операции част 2

## Материал

### Какво правихме предния път

- Философствахме над това как да си направим "чисто" IO
  и императивен синтаксис във функционален език.
- Имплементирахме си наше IO като нещо което променя
  тип `World`
- Направихме го да работи с `do`, като доказахме на хаскел, че е монада

### IO Функции и задачки

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

## Задачи

1. TODO: (T_T)
