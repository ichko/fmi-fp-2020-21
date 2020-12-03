{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}

import Control.Applicative (Alternative (empty, many, (<|>)))
import Data.Bifunctor (Bifunctor (second))
import Data.Char (isDigit, isSpace, ord)

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

parse :: Parser a -> String -> a
parse parser input =
  case runParser parser input of
    Left err -> error $ show err
    Right (_rest, value) -> value

parseA :: Parser Char
parseA = Parser $
  \case
    (h : t) | h == 'a' -> Right (t, h)
    _ -> abort "could not parse a"

parseChar :: Char -> Parser Char
parseChar c = Parser $
  \case
    (h : t) | h == c -> Right (t, c)
    _ -> abort $ "could not parse char " ++ [c]

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

tryRead :: Read a => String -> Parser a
tryRead string = do
  case reads string of
    [(value, _)] -> return value
    _ -> abortParser "could not read value"

parseTrueOrFalse :: Parser Bool
parseTrueOrFalse =
  (parseString "True" <|> parseString "False") >>= tryRead

parseString :: String -> Parser String
parseString = mapM parseChar

parseSpan :: (Char -> Bool) -> Parser String
parseSpan predicate = Parser $ \i ->
  let (matched, rest) = span predicate i in Right (rest, matched)

parseInteger :: Parser Integer
parseInteger = do
  list <- reads <$> parseSpan isDigit
  case list of
    [(number, _)] -> return number
    _ -> abortParser "could not parse number"

parseWS :: Parser String
parseWS = parseSpan isSpace

parseSeparated :: Parser a -> Parser b -> Parser [b]
parseSeparated separator element =
  (:) <$> element <*> many (separator *> element) <|> pure []

arrayParser :: Parser b -> Parser [b]
arrayParser elementParser =
  parseChar '[' *> parseWS *> elements <* parseWS <* parseChar ']'
  where
    elements =
      parseSeparated (parseWS *> parseChar ',' <* parseWS) elementParser

parseIntegerArray :: Parser [Integer]
parseIntegerArray = arrayParser parseInteger

parseIntegerArray' :: Parser [[Integer]]
parseIntegerArray' = arrayParser parseIntegerArray

main :: IO ()
main = do
  print $ runParser parseA "ala-bala"
  print $ runParser parseA "bla-bla"

  print $ runParser (parseChar 'c') "cow-say moo"
  print $ runParser (ord <$> parseChar 'c') "cows"
  print $ runParser (ord <$> parseChar 'y' <* parseChar 'x') "yxz"

  print $ runParser (parseString "world") "world, hello"

  print $ runParser parseTrueOrFalse "True and stuff"
  print $ runParser parseTrueOrFalse "False and stuff"
  print $ runParser parseTrueOrFalse "nothing and stuff"

  print $ runParser (parseSpan isDigit) "1234abcd321"
  print $ runParser parseInteger "1234abcd321"
  print $ runParser parseInteger "abcd321"

  print $
    runParser
      (arrayParser parseTrueOrFalse)
      "[ True,   False , False  ] test"

  print $ runParser parseIntegerArray' "[ [12],  [ 54 , 23]  ]dsa"
  print $ runParser parseIntegerArray' "[ [12],  [ 54 , [23]  ]dsa"
