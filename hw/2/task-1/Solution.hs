module Solution where

data Еxpr a
  = Atom a
  | Add (Еxpr a) (Еxpr a)
  | Subtr (Еxpr a) (Еxpr a)
  | Mul (Еxpr a) (Еxpr a)
  | Div (Еxpr a) (Еxpr a)
  deriving (Show, Eq)

eval :: Еxpr a -> Maybe a
eval = undefined

evaluateString :: String -> Maybe Integer
evaluateString = undefined
