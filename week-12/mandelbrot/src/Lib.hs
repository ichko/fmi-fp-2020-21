module Lib where

-- SRC - <https://github.com/angusjlowe/Haskell-Mandelbrot>

import Graphics.Gloss
import Graphics.Gloss.Raster.Field

green' = makeColorI 30 255 144 255

green'' = makeColorI 0 128 0 255

midnight = makeColorI 25 112 25 255

cobaltg = makeColorI 61 171 89 255

royal1 = makeColorI 65 225 105 255

royal2 = makeColorI 72 255 118 255

royal3 = makeColorI 58 205 95 255

royal4 = makeColorI 39 139 64 255

cfgreen = makeColorI 100 237 149 255

steel = makeColorI 176 222 196 255

steelgreen1 = makeColorI 99 255 184 255

steelgreen2 = makeColorI 79 205 148 255

lightgreen1 = makeColorI 135 255 206 255

lightgreen2 = makeColorI 108 206 166 255

deepgreen1 = makeColorI 0 238 178 255

deepgreen2 = makeColorI 0 255 191 255

peacock = makeColorI 51 201 161 255

cadet = makeColorI 152 255 245 255

turquiose = makeColorI 0 238 229 255

mangblue = makeColorI 3 158 168 255

next :: Point -> Point -> Point
next (u, v) (x, y) = (x * x - y * y + u, 2 * x * y + v)

mandelbrotFunction :: Point -> Point -> [Point]
mandelbrotFunction (ox, oy) (u, v) = iterate (next (u, v)) (ox, oy)

fairlyClose :: Point -> Bool
fairlyClose (x, y) = x * x + y * y < 100

colors :: [Color]
colors = [green', green'', midnight, cobaltg, royal1, royal2, royal3, royal4, cfgreen, steel, turquiose, steelgreen1, steelgreen2, lightgreen1, lightgreen2, deepgreen1, deepgreen2, peacock, cadet, turquiose, mangblue, black]

chooseColor :: [Color] -> [Point] -> Color
chooseColor palette = (palette !!) . length . take (n - 1) . takeWhile fairlyClose
  where
    n = length palette

render :: Float -> Point -> Color
render t (u, v) =
  ( chooseColor colors
      . mandelbrotFunction (ox, oy)
  )
    (u, v)
  where
    ox = sin t / 2
    oy = cos t / 2
