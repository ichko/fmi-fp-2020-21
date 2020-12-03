import Control.Applicative (Alternative ((<|>)))
import Parser
  ( Parseable (..),
    Parser (runParser),
    char,
    end,
    nonWS,
    parse,
    ws,
  )

data Tree a
  = Empty
  | Node a (Tree a) (Tree a)
  deriving (Show)

singleton :: a -> Tree a
singleton a = Node a Empty Empty

parseEmpty :: Parser (Tree a)
parseEmpty = Empty <$ char '*'

parseNode :: Parser a -> Parser (Tree a)
parseNode parserA =
  (\_ _ root _ left _ right _ _ -> Node root left right)
    <$> char '{'
    <*> ws
    <*> parserA
    <*> ws
    <*> parseTree parserA
    <*> ws
    <*> parseTree parserA
    <*> ws
    <*> char '}'

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
