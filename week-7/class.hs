import Control.Monad (forM, forM_, forever, when)

main' :: IO ()
main' = do
  a <- getLine
  b <- getLine
  print [a, b]

main'' :: IO ()
main'' = do
  res <- sequence [getLine, getLine]
  print res

mainMap :: IO ()
mainMap = do
  mapM_ print [1, 2, 3]

mainFor :: IO ()
mainFor = do
  forM_ [1, 2, 3] $ \i -> do
    print i

    line <- getLine

    print (read line + i)

mainWhen :: IO ()
mainWhen = do
  line <- getLine

  when (length line < 2) $ do
    putStrLn "in the when 'block'"
    test <- getLine
    putStrLn test

  putStrLn "After when block"

-- forever
mainMultiplyForever :: IO ()
mainMultiplyForever = do
  forever $ do
    a <- getLine
    b <- getLine
    print $ "Ans: " ++ show (read a * read b)

  putStr "test"

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
