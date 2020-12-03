{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}

module Parser where

import Control.Applicative (Alternative (empty, many, (<|>)))
import Data.Bifunctor (Bifunctor (second))
import Data.Char (isDigit, isSpace, ord)
import Prelude hiding (span)
import qualified Prelude

newtype ParserError
  = GeneralError String
  deriving (Show)

abort :: String -> Either ParserError b
abort = Left . GeneralError

type ParserResult a = Either ParserError (String, a)

newtype Parser a = Parser
  { runParser :: String -> ParserResult a
  }

abortParser :: String -> Parser a
abortParser error = Parser $ \_ -> abort error

a :: Parser Char
a = Parser $
  \case
    (h : t) | h == 'a' -> Right (t, h)
    _ -> abort "could not parse a"

char :: Char -> Parser Char
char c = Parser $
  \case
    (h : t) | h == c -> Right (t, c)
    _ -> abort $ "could not parse char " ++ [c]

nom :: Parser Char
nom = Parser $
  \case
    (h : t) -> Right (t, h)
    _ -> abort "could not pase single char"

nomAll :: Parser String
nomAll = many nom

instance Functor Parser where
  fmap mapper parser =
    Parser $ fmap (second mapper) . runParser parser

instance Applicative Parser where
  pure a = Parser $ Right . (,a)
  Parser fp <*> Parser vp = Parser $ \i -> do
    (i', f) <- fp i
    (i'', v) <- vp i'
    return (i'', f v)

instance Monad Parser where
  Parser p >>= func = Parser $ \i -> do
    (i', a) <- p i
    runParser (func a) i'

instance Alternative Parser where
  empty = Parser $ \_ -> abort ""
  Parser pa <|> Parser pb = Parser $ \i ->
    case pa i of
      Left _ -> pb i
      result -> result

instance Semigroup a => Semigroup (Parser a) where
  pa <> pb = pa >>= \a -> pb >>= \b -> return (a <> b)

instance (Monoid a) => Monoid (Parser a) where
  mempty = return $ mempty a

tryRead :: Read a => String -> Parser a
tryRead string = do
  case reads string of
    [(value, _)] -> return value
    _ -> abortParser "could not read value"

bool :: Parser Bool
bool =
  (string "True" <|> string "False") >>= tryRead

string :: String -> Parser String
string = mapM char

span :: (Char -> Bool) -> Parser String
span predicate = Parser $ \i ->
  let (matched, rest) = Prelude.span predicate i in Right (rest, matched)

natural :: Parser Integer
natural = do
  list <- reads <$> span isDigit
  case list of
    [(number, _)] -> return number
    _ -> abortParser "could not parse number"

ws :: Parser String
ws = span isSpace

nonWS :: Parser String
nonWS = span (not . isSpace)

idP :: Parser ()
idP = pure ()

integer :: Parser Integer
integer =
  idP
    *> natural
    <|> negate
    <$> (char '-' *> ws *> natural)

separated :: Parser a -> Parser b -> Parser [b]
separated separator element =
  (:) <$> element <*> many (separator *> element) <|> pure []

split :: String -> Parser b -> Parser [b]
split separator =
  separated (ws *> string separator <* ws)

list :: Parser b -> Parser [b]
list elementParser =
  char '[' *> ws *> split "," elementParser <* ws <* char ']'

intList :: Parser [Integer]
intList = list integer

intList' :: Parser [[Integer]]
intList' = list intList

end :: Parser ()
end = (*>) ws $
  Parser $ \case
    [] -> Right ([], ())
    _ -> abort "expected end of string"

class Parseable p where
  parser :: Parser p

instance Parseable Integer where
  parser = integer

instance Parseable Int where
  parser = fromIntegral <$> integer

instance Parseable Char where
  parser = nom

instance Parseable String where
  parser = nomAll

instance Parseable a => Parseable [a] where
  parser = list parser

instance Parseable Bool where
  parser = bool

parse :: Parseable p => String -> p
parse input =
  case runParser parser input of
    Left err -> error $ show err
    Right (_rest, value) -> value

main' :: IO ()
main' = do
  print $ runParser a "ala-bala"
  print $ runParser a "bla-bla"

  print $ runParser (char 'c') "cow-say moo"
  print $ runParser (ord <$> char 'c') "cows"
  print $ runParser (ord <$> char 'y' <* char 'x') "yxz"

  print $ runParser (string "world") "world, hello"

  print $ runParser bool "True and stuff"
  print $ runParser bool "False and stuff"
  print $ runParser bool "nothing and stuff"

  print $ runParser (span isDigit) "1234abcd321"
  print $ runParser natural "1234abcd321"
  print $ runParser natural "abcd321"

  print $ runParser (list bool) "[ True,   False , False  ] test"

  print $ runParser intList' "[ [12],  [ 54 , 23]  ]dsa"
  print $ runParser intList' "[ [12],  [ 54 , [23]  ]dsa"
