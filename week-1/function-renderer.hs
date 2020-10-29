import Control.Concurrent (threadDelay)
import Control.DeepSeq (deepseq)

defaultCmap :: [Char]
defaultCmap = " .^*#0@"

normalizeGrid :: (Fractional a, Ord a) => [[a]] -> [[a]]
normalizeGrid grid =
  let max = maximum $ map maximum grid
      min = minimum $ map minimum grid
   in [[(p - min) / (max - min) | p <- row] | row <- grid]

shadePixel :: RealFrac b => b -> [a] -> a
shadePixel n cmap =
  let cml = fromIntegral $ length cmap
      s = floor (n * (cml - 0.0001))
   in cmap !! s

grid :: (Num t, Enum t) => (t -> t -> a) -> t -> [[a]]
grid f step =
  [ [ f x y
      | x <- [-1, -1 + step .. 1]
    ]
    | y <- [-1, -1 + step .. 1]
  ]

shadeGrid :: RealFrac b => [[b]] -> [a] -> [[a]]
shadeGrid grid cmap =
  [ [ shadePixel pixel cmap
      | pixel <- row
    ]
    | row <- normalizeGrid grid
  ]

render :: [[Char]] -> [Char]
render canvas =
  let newLinedCanvas = [concat [[p, p] | p <- row] ++ "\n" | row <- canvas]
   in concat newLinedCanvas

func :: Floating a => a -> a -> a -> a
func t x y = sin (x * y * 10 + t / 10)

saveRender :: (RealFrac b, Enum b, Floating b) => b -> IO ()
saveRender t =
  writeFile "render.txt" $ render $ shadeGrid (grid (func t) 0.05) defaultCmap

printRender :: (RealFrac b, Enum b, Floating b) => b -> IO ()
printRender t =
  let canvas = render $ shadeGrid (grid (func t) 0.05) defaultCmap
      _ = canvas `deepseq` ()
   in putStrLn canvas

clear :: IO ()
clear = putStr "\ESC[2J"

loop :: (RealFrac t, Enum t, Floating t) => t -> IO b
loop t = do
  saveRender t
  threadDelay 1000000
  loop (t + 1)

main :: IO b
main = loop 0
