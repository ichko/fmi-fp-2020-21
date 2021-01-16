module Main where

import Graphics.Gloss
import Graphics.Gloss.Raster.Field
import Lib

width = 800

height = 800

main :: IO ()
main =
  animate
    (InWindow "Mandelbrot" (width, height) (2800, 500))
    white
    $ \t -> Pictures [makePicture width height 1 1 (render t)]
