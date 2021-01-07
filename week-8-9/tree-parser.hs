import Control.Applicative (Alternative ((<|>)))
import Parser

data Tree a
  = Empty
  | Node a (Tree a) (Tree a)
  deriving (Show)

singleton :: a -> Tree a
singleton a = Node a Empty Empty

parseEmpty :: Parser (Tree a)
parseEmpty = Empty <$ char '*'

-- Monadic sequencing of parsers
parseNode' :: Parser Int -> Parser (Tree Int)
parseNode' parserA = do
  root <- char '{' *> ws *> parserA <* ws
  left <- parseTree parserA <* ws
  right <- parseTree parserA <* ws <* char '}'

  if root < 5
    then abortParser "root value should be always >= 5"
    else return $ Node root left right

-- Applicative sequencing of parsers
parseNode :: Parser a -> Parser (Tree a)
parseNode parserA =
  Node
    <$> (char '{' *> ws *> parserA <* ws)
    <*> (parseTree parserA <* ws)
    <*> parseTree parserA

parseTree :: Parser a -> Parser (Tree a)
parseTree parserA = parseEmpty <|> parseNode parserA

wholeTree :: Parser a -> Parser (Tree a)
wholeTree p = ws *> parseTree p <* end

instance (Parseable a) => Parseable (Tree a) where
  parser = wholeTree parser

main :: IO ()
main = do
  print (parse "*" :: Tree Int)
  print (parse "{5 * *}" :: Tree Int)
  print (parse "{1 {3 * *} *}" :: Tree Int)
  print (parse "{1 * {3 * *}}" :: Tree Int)
  print (parse "{1{4{8**}*}{3*{2**}}}  " :: Tree Int)
  print $ runParser (wholeTree nonWS) "{root {left * *} {right * *}}"
  print (parse "{1 * *}  end?" :: Tree Int)
