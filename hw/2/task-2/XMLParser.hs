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

xmlParser :: Parser XMLObject
xmlParser = Text <$> nomAll -- Implement This
