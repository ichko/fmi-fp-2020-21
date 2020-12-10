{-# LANGUAGE LambdaCase #-}

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

-- парсване на инт - tryRead декоратор
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

main = undefined
