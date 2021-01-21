{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE LambdaCase #-}

-- Credit for this goes to
-- Georgi Lyubenov - <https://github.com/googleson78>

import Control.Applicative (Alternative (..))
import Control.Monad.Trans.List (ListT (..))
import Control.Monad.Trans.State (StateT (..))
import Data.Functor.Identity (Identity (..))

newtype Parser a = Parser {runParser :: String -> [(a, String)]}
  deriving (Functor, Applicative, Monad, Alternative, MonadFail) via StateT String (ListT Identity)

nom :: Parser Char
nom = Parser \case
  [] -> []
  x : xs -> [(x, xs)]

char :: Char -> Parser Char
char a = do
  x <- nom
  if x == a
    then pure x
    else empty

xaStar :: Parser String
xaStar = many (char 'x' <|> char 'a')

-- > runParser xa "a"
-- [('a',"")]
-- > runParser xa "x"
-- [('x',"")]
-- > runParser xa "xa"
-- [('x',"a")]
