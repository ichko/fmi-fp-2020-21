{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE TupleSections #-}

-- SRC - [YouTube] What is IO monad?
-- https://www.youtube.com/watch?v=fCoQb-zqYDI

import World (World (..), getLine', putStrLn')

greet :: IO ()
greet = do
  name <- getLine
  putStrLn name

greet' :: World -> World
greet' w =
  let (name, w2) = getLine' w
   in putStrLn' name w2

-- bad
branch :: World -> (World, World)
branch w =
  ( putStrLn' "haskell is life" w,
    putStrLn' "haskell su" w
  )

-- това е като data ама работи само за типове с
-- един конструктор с едно поле
-- казва на компилатора че може да третира новия тип и типа на полето в
-- конструктора по един и същи начин
newtype WorldT a = WorldT (World -> (a, World)) deriving (Functor)

instance Show (WorldT a) where
  show _ = "WorldT"

-- show what is Functor
-- newtype Box a = Box a deriving (Functor, Show)

-- a :: Box Integer
-- a = fmap (+ 1) (Box 1)

getLineT :: WorldT String
getLineT = WorldT getLine'

putStrLnT :: String -> WorldT ()
putStrLnT s = WorldT (\w -> ((), putStrLn' s w))

(>>>=) ::
  WorldT a -> -- World -> (a, World)) - света ни дава стойност а
  (a -> WorldT b) -> -- a -> World -> (b, World) - използваме а за да трансформираме света и той ни дава б
  WorldT b -- (World -> (b, World))
(WorldT wt) >>>= wft =
  WorldT
    ( \w ->
        let (a, w2) = wt w
            (WorldT wtb) = wft a
         in wtb w2
    )

greetT :: WorldT ()
greetT =
  getLineT >>>= \name ->
    putStrLnT name >>>= \_ ->
      putStrLnT "End"

instance Applicative WorldT where
  pure x = WorldT (x,)
  wtf <*> wt = wtf >>>= \f -> wt >>>= \a -> pure (f a)

instance Monad WorldT where
  (>>=) = (>>>=)

doGreet :: WorldT ()
doGreet = do
  name <- getLineT
  putStrLnT $ "Zdr " ++ name

-- in GHCi: let (WorldT t) = doGreet in t World
