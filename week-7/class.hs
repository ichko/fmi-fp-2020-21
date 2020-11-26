import Control.Monad (forM, forever)

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
