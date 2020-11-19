import Control.Monad

mainWorld :: IO ()
mainWorld = putStrLn "Hello World"

mainGreet :: IO ()
mainGreet = do
  putStrLn "Hello, what's your name?"
  name <- getLine
  putStrLn ("Hey " ++ name ++ ", you rock!")

-- > By convention, we don't usually specify a type declaration for main
mainCalculator :: IO ()
mainCalculator = do
  putStrLn "a + b = ? калкулатор\nдай a:"
  a <- getLine
  putStrLn "дай b:"
  b <- getLine
  let aInt = read a :: Int
      bInt = read b :: Int
      c = show (aInt + bInt)

  putStrLn $ a ++ " + " ++ b ++ " = " ++ c

mainRepl :: IO ()
mainRepl = do
  line <- getLine
  if null line
    then return ()
    else do
      -- notice the indentation (it is important)
      putStrLn $ doPureWork line
      mainRepl

doPureWork :: String -> String
doPureWork str = tree n
  where
    n = read str :: Int
    row m = replicate m ' ' ++ "#" ++ replicate (2 * (n - m)) '#' ++ "\n"
    tree 0 = row n
    tree m = row m ++ tree (m - 1)

-- как return се ориентира за типа си (обичайно от контекста)
mainReturnType :: IO Integer
mainReturnType = do
  return 5

-- Също работи
mainReturnType' :: Maybe Integer
mainReturnType' = do
  four <- Just 3
  return (four + 1)

-- какво ни дава do като синтаксис
mainDo :: IO ()
mainDo = do
  name <- getLine
  putStr ("Zdr" ++ name)
  putStr "Ala"
  putStr "Bala"

-- това се случва зад колисите
mainNoDo :: IO ()
mainNoDo =
  getLine >>= \name ->
    putStr ("Zdr" ++ name)
      >> putStr "Ala"
      >> putStr "Bala"

-- forever
mainMultiplyForever :: IO b
mainMultiplyForever = forever $ do
  a <- getLine
  b <- getLine
  print $ "Ans: " ++ show (read a * read b)

mainForM :: IO ()
mainForM = do
  putStrLn "Running mainForM"
  result <- forM [1, 2, 3] $ \a -> do
    b <- getLine
    print (a + read b)
    return (a ** 2 + read b)

  putStrLn "The result is:"
  print result

main :: IO ()
main = do
  interact $ unwords . map reverse . words
