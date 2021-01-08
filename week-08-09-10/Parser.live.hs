{-# LANGUAGE LambdaCase #-}

import Control.Applicative
import Data.Char

-- Какво е парсър
-- Как хендълваме грешки
-- да изядем един символ
-- да изядем нещо при условие
-- да изядем конкретен символ
-- да изядем стринг - мап чар
-- sequanceA
-- Ама трябва да сме апликативни и да сме функтор
-- парсване на стринг

-- парсване на тру или фолс
-- имплементиране на алтернатива

-- парсване на инт - tryReading декоратор
-- reads

type ParseError = String

type ParseResult a = Either ParseError (String, a)

newtype Parser a = Parser
  { runParser :: String -> ParseResult a
  }

nom :: Parser Char
nom =
  Parser $
    \case
      [] -> Left "could not nom from empty string"
      (h : t) -> Right (t, h)

charP :: Char -> Parser Char
charP c = Parser $
  \case
    (h : t) | h == c -> Right (t, h)
    _ -> Left "error charP"

instance Functor Parser where
  fmap f (Parser p) = Parser $ \input ->
    case p input of
      Left error -> Left error
      Right (rest, a) -> Right (rest, f a)

instance Applicative Parser where
  pure a = Parser $ \input -> Right (input, a)

  (Parser pf) <*> (Parser pa) = Parser $ \i -> do
    (i', f) <- pf i
    (i'', a) <- pa i'
    return (i'', f a)

instance Monad Parser where
  (Parser pa) >>= apb = Parser $ \i -> do
    (i', a) <- pa i
    runParser (apb a) i'

stringP :: String -> Parser String
stringP = mapM charP

instance Alternative Parser where
  empty = Parser $ \_ -> Left "empty parser"
  (Parser pa) <|> (Parser pb) = Parser $ \i ->
    case pa i of
      Left error -> pb i
      result -> result

trueParser :: Parser Bool
trueParser = True <$ stringP "true"

falseParser :: Parser Bool
falseParser = False <$ stringP "false"

boolP :: Parser Bool
boolP = trueParser <|> falseParser

tryReading :: (Read a) => Parser String -> Parser a
tryReading (Parser ps) = Parser $ \i -> do
  (rest, str) <- ps i
  case reads str of
    [] -> Left "could not read parsed string value"
    [(a, _)] -> Right (rest, a)

spanP :: (Char -> Bool) -> Parser String
spanP predicate = Parser $ \i ->
  let (matched, rest) = span predicate i
  in Right (rest, matched)

integerP :: Parser Integer
integerP = tryReading $ spanP isDigit

wsP :: Parser String
wsP = spanP isSpace

exampleP =
  (\_ _ a _ _ _ b _ _ -> (a, b))
  <$> charP '('
  <*> wsP 
  <*> integerP
  <*> wsP
  <*> charP ','
  <*> wsP
  <*> integerP
  <*> wsP
  <*> charP ')'

example =
  runParser (tryReading $ stringP "123" :: Parser Int) "123 abc"


main = undefined
