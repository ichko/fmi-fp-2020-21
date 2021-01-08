{-# LANGUAGE BangPatterns #-}

module World where

import System.IO.Unsafe (unsafePerformIO)

data World = World deriving (Show)

instance Eq World where
  _ == _ = False

putStrLn' :: String -> World -> World
putStrLn' s !w = unsafePerformIO (putStrLn s >> return w)

getLine' :: World -> (String, World)
getLine' !w = unsafePerformIO (getLine >>= (\s -> return (s, w)))
