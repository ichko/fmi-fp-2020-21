import Control.Concurrent (threadDelay)
import Data.Fixed (mod')

-- Relevant code with increasing complexity
-- <https://www.shadertoy.com/view/Ws3Bz4> - static ray marcher
-- <https://www.shadertoy.com/view/WdcfR4> - flying through space
-- <https://www.shadertoy.com/view/Ms2yDt> - flying through Mandelbulbs
{--
#define MAX 64
#define EPS 0.1

float de(vec3 pos) {
    pos = mod(pos, 2.0) - 1.0;
    pos *= sin(pos * 2.0);
    return length(pos) - 0.2;
}

float march(vec3 ro, vec3 rd) {
    float dist = 0.0;
    for(int i = 0;i < MAX;++i) {
        vec3 pos = ro + rd * dist;
        float d = de(pos);
        dist += d;
        if(d < EPS) break;
    }

    return dist / float(MAX) * 3.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    float ar = iResolution.x / iResolution.y;
    vec2 uv = fragCoord.xy / iResolution.y - vec2(ar * 0.5, 0.5);

    vec3 ro = vec3(0, 0, -1);
    vec3 rd = normalize(vec3(uv, 1.0));
    float i = march(ro, rd);
    vec3 color = vec3(i, 0.0, 0.5);

	fragColor = vec4(color, 1.0);
}
--}

nonIntRem :: RealFrac a => a -> a -> a
nonIntRem x y = x - (y * (fromIntegral $ truncate (x / y)))

data Vector a = Vector a a a deriving (Show, Read, Eq)

vec :: a -> a -> a -> Vector a
vec = Vector

zeroVec :: Vector Integer
zeroVec = vec 0 0 0

instance (Num a, Show a) => Num (Vector a) where
  Vector x1 y1 z1 + Vector x2 y2 z2 = Vector (x1 + x2) (y1 + y2) (z1 + z2)
  Vector x1 y1 z1 * Vector x2 y2 z2 = Vector (x1 * x2) (y1 * y2) (z1 * z2)
  negate (Vector x y z) = Vector (- x) (- y) (- z)
  abs (Vector x y z) = Vector (abs x) (abs y) (abs z)
  signum (Vector x y z) = Vector (signum x) (signum y) (signum z)
  fromInteger i = Vector (fromInteger i) (fromInteger i) (fromIntegral i)

mod'' :: Real a => Vector a -> a -> Vector a
mod'' (Vector x y z) n =
  vec (mod' x n) (mod' y n) (mod' z n)

sin' :: Floating a => Vector a -> Vector a
sin' (Vector x y z) = vec (sin x) (sin y) (sin z)

len :: Floating a => Vector a -> a
len (Vector x y z) = sqrt $ x ^ 2 + y ^ 2 + z ^ 2

scale :: Num a => Vector a -> a -> Vector a
scale (Vector x y z) n = vec (x * n) (y * n) (z * n)

norm :: Floating a => Vector a -> Vector a
norm v@(Vector x y z) = let l = len v in vec (x / l) (y / l) (z / l)

grid :: (Enum a, Fractional a) => (a, a) -> (a, a) -> a -> [[(a, a)]]
grid (x_min, x_max) (y_min, y_max) size =
  let stepx = (x_max - x_min) / size
      stepy = (y_max - y_min) / size
   in [ [(x, y) | x <- [x_min, x_min + stepx .. x_max]]
        | y <- [y_min, y_min + stepy .. y_max]
      ]

mapGrid :: (t -> a) -> [[t]] -> [[a]]
mapGrid f grid = [[f x | x <- row] | row <- grid]

showRealGrid :: RealFrac a => [[a]] -> [Char] -> [Char]
showRealGrid grid cmap = string_grid
  where
    shade_pixel p =
      let cml = fromIntegral $ length cmap
          s = floor (p * (cml - 0.0001))
       in cmap !! s

    normalized_grid =
      let max = maximum $ map maximum grid
          min = minimum $ map minimum grid
       in [[(p - min) / (max - min) | p <- row] | row <- grid]

    string_grid =
      concat
        [ concat [let sp = shade_pixel p in sp : [sp] | p <- row] ++ "\n"
          | row <- normalized_grid
        ]

clear :: (Show a1, Show a2) => a2 -> a1 -> [Char]
clear w h = "\ESC[" ++ show h ++ "A\ESC[" ++ show w ++ "D"

ditheredCmap :: [Char]
ditheredCmap = reverse "                                           ░░░░░▒▒▒▒▒▓▓▓▓▓███"

shader t (u, v) = shade
  where
    ro = vec t (1.53 * t) (t * 2.5)
    rd = norm $ vec u v 1

    de pos =
      let one = vec 1 1 1
          modPos = (mod'' pos 2.0) - one
          -- sinPos = sin' modPos
          r = 0.5
       in len modPos - r

    max = 16
    eps = 0.1

    march its dist =
      let pos = ro + scale rd dist
          d = de pos
          result = dist / max
       in if its == 0 || d < eps
            then result
            else march (its - 1) (dist + d)

    shade = march max 0

render screenSize t cmap = showRealGrid mappedGrid cmap
  where
    gridInstance = grid (-1, 1) (-1, 1) screenSize
    mappedGrid = mapGrid (shader t) gridInstance

loop t = do
  let size = 40
  putStr $ clear (round $ size) (round $ size)
  putStr $ render (size - 1) (t / 50) ditheredCmap
  threadDelay 10
  loop (t + 1)

main :: IO ()
main = loop 0
