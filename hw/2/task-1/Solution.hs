{-# LANGUAGE LambdaCase #-}

module Solution where

import Control.Applicative
import ParserUtils

data Еxpr a
  = Atom a
  | Add (Еxpr a) (Еxpr a)
  | Subtr (Еxpr a) (Еxpr a)
  | Mul (Еxpr a) (Еxpr a)
  | Div (Еxpr a) (Еxpr a)
  deriving (Show, Eq)

nothingIfZero :: (Num a, Eq a) => a -> Maybe a
nothingIfZero 0 = Nothing
nothingIfZero a = Just a

errorIfZero :: (Eq a, Num a) => a -> Parser a
errorIfZero 0 = abortParser "unexpected zero"
errorIfZero a = return a

eval :: (Num a, Integral a) => Еxpr a -> Maybe a
eval (Atom a) = Just a
eval (Add a b) = (+) <$> eval a <*> eval b
eval (Subtr a b) = (-) <$> eval a <*> eval b
eval (Mul a b) = (*) <$> eval a <*> eval b
eval (Div a b) = div <$> eval a <*> (eval b >>= nothingIfZero)

evaluateString :: String -> Maybe Integer
evaluateString inp =
  case runParser mathExpr inp of
    Right ([], value) -> Just value
    Right (rest, _) -> error $ "non empty parser finished: " ++ rest
    Left "division by zero" -> Nothing
    Left msg -> error msg

-- https://stackoverflow.com/questions/59508862/using-parser-combinator-to-parse-simple-math-expression
-- expression =
--     term
--     | expression "+" term
--     | expression "-" term .
-- term =
--     factor
--     | term "*" factor
--     | term "/" factor .
-- factor =
--     number
--     | "(" expression ")" .

expression :: Parser Integer
expression = do
  left <- term
  right <-
    many
      ( (negate <$> (ws *> char '-' *> ws *> term))
          <|> (ws *> char '+' *> ws *> term)
      )
  return (left + sum right)

-- This needs some refactoring
term :: Parser Integer
term = Parser $ \i -> do
  (i', left) <- runParser factor i
  let rightP =
        some
          ( ((,) <$> (ws *> char '*' <* ws) <*> factor)
              <|> ((,) <$> (ws *> char '/' <* ws) <*> (factor >>= errorIfZero))
          )
  case runParser rightP i' of
    Left "unexpected zero" -> Left "division by zero"
    Right (i'', right) -> return (i'', result left right)
    _ -> return (i', result left [])
  where
    result :: Integer -> [(Char, Integer)] -> Integer
    result =
      foldl
        ( \l -> \case
            ('*', v) -> l * v
            ('/', v) -> l `div` v
        )

factor :: Parser Integer
factor =
  orChain
    <|> ws *> integer <* ws
    <|> char '(' *> expression <* char ')' <* ws

mathExpr :: Parser Integer
mathExpr = ws *> expression <* ws
