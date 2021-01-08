type Expression = String

solve :: (Fractional p, Read p) => Expression -> p
solve expression
  | null result = error "Invalid Expression"
  | otherwise = head result
  where
    reducer (a : b : rest) "+" = (a + b) : rest
    reducer (a : b : rest) "-" = (a - b) : rest
    reducer (a : b : rest) "*" = (a * b) : rest
    reducer (a : b : rest) "/" = (a / b) : rest
    reducer stack num = read num : stack

    tokens = words expression
    result = foldl reducer [] tokens

solutions :: [Double]
solutions =
  map
    solve
    [ "10 4 3 + 2 * -",
      "2 3 +",
      "90 34 12 33 55 66 + * - +",
      "90 34 12 33 55 66 + * - + -",
      "90 3 -"
    ]
