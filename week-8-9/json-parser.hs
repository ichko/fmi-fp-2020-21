-- Resources
-- [Gitgub / googleson78]
-- Курса от миналата година
-- <https://github.com/triffon/fp-2019-20/blob/master/exercises/lab/exercises/14-parsing-do.hs>

-- [YouTube / Tsoding]
-- JSON Parser 100% From Scratch in Haskell (only 111 lines)
-- <https://www.youtube.com/watch?v=N9RUqGYuGfw>
-- <https://github.com/tsoding/haskell-json/blob/bafd97d96b792edd3e170525a7944b9f01de7e34/Main.hs>

data JsonValue
  = Null
  | Bool Bool
  | Number Integer -- (only integers!)
  | String String -- (no escapes!)
  | Arrays [JsonValue]
  | Object [(String, JsonValue)]
  deriving (Show)
