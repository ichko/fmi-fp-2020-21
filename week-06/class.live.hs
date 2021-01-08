main :: IO ()
main = do
  a <- getLine
  putStrLn $ "Hello, " ++ a

mainActual :: IO ()
mainActual =
  getLine >>= \a ->
    putStrLn $ "Hello, " ++ a
