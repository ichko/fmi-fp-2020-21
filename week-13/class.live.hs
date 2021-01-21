{-# LANGUAGE DeriveFunctor #-}

import Control.Monad ((<=<))

twice :: (Num a) => a -> a
twice = (* 2)

quadruple = twice . twice

newtype Writer m a = Writer
  { runWriter :: (a, m)
  }
  deriving (Functor)

instance (Monoid m) => Applicative (Writer m) where
  pure a = Writer (a, mempty)
  (Writer (f, mf)) <*> (Writer (a, ma)) =
    Writer (f a, mf <> ma)

instance (Monoid m) => Monad (Writer m) where
  (Writer (a, ma)) >>= func =
    let (Writer (b, mb)) = func a in Writer (b, ma <> mb)

twice' :: Integer -> Writer String Integer
twice' x = Writer (twice x, "Doubled " ++ show x ++ "\n")

quadruple' :: Integer -> Writer String Integer
quadruple' = twice' <=< twice'

-- foo :: IO Integer -> Integer
-- foo _ = 1

-- ioVal :: IO Integer
-- ioVal = return 3

-- unpackedIO :: Integer
-- unpackedIO = let (IO a) = ioVal in a

newtype Reader r a = Reader
  { runReader :: r -> a
  }
  deriving (Functor)

instance Applicative (Reader r) where
  pure = Reader . const
  (Reader rfa) <*> (Reader ra) =
    Reader $ \r -> rfa r (ra r)

instance Monad (Reader r) where
  (Reader ra) >>= func =
    Reader $ \r -> let (Reader rb) = func (ra r) in rb r

ask :: Reader a a
ask = Reader id

facultyNumber :: Reader String (Maybe Int)
facultyNumber = do
  name <- ask
  let mem = [("IZ", 81125), ("AD", 81126)]
  return (lookup name mem)

greetStudent :: Maybe Int -> Reader String String
greetStudent maybeFn = do
  name <- ask
  case maybeFn of
    Nothing -> return $ "Student " ++ name ++ " was not found in the DB!"
    (Just fn) -> return $ "Hello, " ++ name ++ " (" ++ show fn ++ ")"

requestStudentGreeting :: Reader String String
requestStudentGreeting = do
  fn <- facultyNumber
  greetStudent fn

main :: IO ()
main = do
  name <- getLine
  putStrLn $ runReader requestStudentGreeting name
