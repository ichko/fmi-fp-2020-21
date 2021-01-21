{-# LANGUAGE DeriveFunctor #-}

import Control.Monad ((<=<))

-- Stolen form - <https://adit.io/posts/2013-06-10-three-useful-monads.html>

newtype Writer m a = Writer
  { runWriter :: (a, m)
  }
  deriving (Functor)

instance (Monoid m) => Applicative (Writer m) where
  pure a = Writer (a, mempty)
  (Writer (fa, fm)) <*> (Writer (a, am)) =
    Writer (fa a, fm <> am)

instance (Monoid m) => Monad (Writer m) where
  (Writer (a, am)) >>= func =
    let (Writer (b, bm)) = func a in Writer (b, am <> bm)

tell :: String -> Writer String ()
tell str = Writer ((), str)

twice :: (Num a, Show a) => a -> Writer String a
twice a = do
  tell ("I twiced " ++ show a ++ "\n")
  return (a * a)

quadruple :: Integer -> Writer String Integer
quadruple = twice <=< twice

interleave :: [a] -> [a] -> [a]
interleave (x : xs) ys = x : interleave ys xs

cartesian = foldl1 interleave

main :: a
main = undefined
