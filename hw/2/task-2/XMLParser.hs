{-# LANGUAGE NamedFieldPuns #-}

module XMLParser where

import Control.Applicative
import Data.Char
import ParserUtils
import Prelude hiding (span)

type Attribute = (String, String)

data TagElement = TagElement
  { name :: String,
    attributes :: [Attribute],
    children :: [XMLObject]
  }
  deriving (Show, Read, Eq)

data XMLObject
  = Text String
  | Element TagElement
  deriving (Show, Read, Eq)

conditionedParser :: String -> (a -> Bool) -> Parser a -> Parser a
conditionedParser error cond (Parser p) = Parser $ \i -> do
  (i', a) <- p i
  let test = cond a
  if test
    then Right (i', a)
    else abort error

shouldNotBeEmpty :: Foldable t => String -> Parser (t a) -> Parser (t a)
shouldNotBeEmpty msg = conditionedParser msg (not . null)

textParser :: Parser XMLObject
textParser = Text <$> shouldNotBeEmpty "text" (span (/= '<'))

tagIdentifier :: Parser String
tagIdentifier =
  shouldNotBeEmpty
    "identifier should not start with '/'"
    $ span (\c -> not (isSpace c) && c /= '>' && c /= '/')

attrKeyParser :: Parser String
attrKeyParser = span (\c -> not (isSpace c) && c /= '=')

attrValueParser :: Parser String
attrValueParser = stringLiteral

attrParser :: Parser (String, String)
attrParser =
  (,)
    <$> (attrKeyParser <* ws <* char '=')
    <*> (ws *> attrValueParser)

openTag :: Parser (String, [(String, String)])
openTag =
  (\_ name attrs _ -> (name, attrs))
    <$> char '<'
    <*> (tagIdentifier <* ws)
    <*> many (attrParser <* ws)
    <*> char '>'

tagContent :: Parser [XMLObject]
tagContent =
  some (ws *> tagParser) <|> ((: []) <$> textParser) <|> pure []

closeTag :: Parser String
closeTag = string "</" *> tagIdentifier <* char '>'

tagParser :: Parser XMLObject
tagParser =
  ( \(name, attributes) children _ ->
      Element $ TagElement {name, attributes, children}
  )
    <$> openTag
    <*> tagContent
    <*> closeTag
    <* ws

xmlParser :: Parser XMLObject
xmlParser = ws *> tagParser <* ws

main' :: IO ()
main' = do
  print $ runParser textParser "test <p>"
  print $ runParser attrParser "ala=\"test\""
  print $ runParser (many (ws *> attrParser)) "ala=\"test\" src=\"http://...\""
  print $
    runParser
      (many (ws *> attrParser))
      "onlod=\"alabal()\" src=\"test\\\""

  print $ runParser xmlParser "<simple-tag>test</simple-tag>"
  print $ runParser xmlParser "<body> <p>test</p>  </body>"
  print $ runParser xmlParser "<a style = \"test\"><p>test</p></a>"
  print $ runParser xmlParser "<a><p></p></a>"
