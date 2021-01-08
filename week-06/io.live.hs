import World (World (..), getLine', putStrLn')

greet :: IO ()
greet = do
  name <- getLine
  putStrLn $ "Hello, " ++ name

gree' :: World -> World
gree' w =
  let (name, w1) = getLine' w
   in putStrLn' ("Hello, " ++ name) w1

branch :: World -> (World, World)
branch w =
  ( putStrLn' "Haskell is life" w,
    putStrLn' "Haskell sucks" w
  )

newtype WorldM a = WorldM (World -> (a, World))

getLineM :: WorldM String
getLineM = WorldM getLine'

putStrLnM :: String -> WorldM ()
putStrLnM s = WorldM (\w -> ((), putStrLn' s w))

(>>>=) ::
  WorldM a -> -- World -> (a, World)
  (a -> WorldM b) -> -- a -> World -> (b, World)
  WorldM b
(WorldM wma) >>>= wmf =
  WorldM
    ( \w ->
        let (a, w1) = wma w
            (WorldM wmb) = wmf a
         in wmb w1
    )

greetM :: WorldM ()
greetM =
  getLineM >>>= \name ->
    putStrLnM ("Hello, " ++ name) >>>= \_ ->
      putStrLnM "AlaBala"
