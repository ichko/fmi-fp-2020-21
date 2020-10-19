import Control.Concurrent
import Control.DeepSeq

defaultCmap = " .^*#0@"

normalizeGrid grid =
  let max = maximum $ map maximum grid
      min = minimum $ map minimum grid
   in [[(p - min) / (max - min) | p <- row] | row <- grid]

shadePixel n cmap =
  let cml = fromIntegral $ length cmap
      s = floor (n * (cml - 0.0001))
   in cmap !! s

grid f step =
  [ [ f x y
      | x <- [-1, -1 + step .. 1]
    ]
    | y <- [-1, -1 + step .. 1]
  ]

shadeGrid grid cmap =
  [ [ shadePixel pixel cmap
      | pixel <- row
    ]
    | row <- normalizeGrid grid
  ]

render canvas =
  let newLinedCanvas = [concat [[p, p] | p <- row] ++ "\n" | row <- canvas]
   in concat newLinedCanvas

func t x y = sin (x * y * 10 + t / 10)

saveRender t =
  writeFile "render.txt" $ render $ shadeGrid (grid (func t) 0.05) defaultCmap

printRender t =
  let canvas = render $ shadeGrid (grid (func t) 0.05) defaultCmap
      _ = canvas `deepseq` ()
   in putStrLn canvas

clear = putStr "\ESC[2J"

a = 2

loop t = do
  saveRender t
  threadDelay 1000000
  loop (t + 1)

main = loop 0
