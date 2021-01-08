module AssertExpectedScreen where

import Data.List (intercalate)
import qualified Data.Map as M
import Test.HUnit (assertEqual)

screens =
  M.fromList
    [ ( "no moves game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "+-----------+",
          "Player o select your move:"
        ]
      ),
      ( "one move game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "|o| | | | | |",
          "+-----------+",
          "Player x select your move:"
        ]
      ),
      ( "few moves game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| |o| | | | |",
          "|o|x| | | | |",
          "+-----------+",
          "Player x select your move:"
        ]
      ),
      ( "simple horizontal finished game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | | | |",
          "| | | | |o| |",
          "|x|x|x|x|o| |",
          "|o|x|o|x|o|o|",
          "+-----------+",
          "Game Over\nwinner: [x]"
        ]
      ),
      ( "simple vertical finished game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| |o| | | | |",
          "| |o| | | |x|",
          "| |o| | | |x|",
          "| |o| | | |x|",
          "+-----------+",
          "Game Over\nwinner: [o]"
        ]
      ),
      ( "simple diagonal finished game",
        [ "+-----------+",
          "| | | | | | |",
          "| | | | | | |",
          "| | | |o| | |",
          "| | |o|o| | |",
          "|x|o|o|o| |x|",
          "|o|x|x|x| |x|",
          "+-----------+",
          "Game Over\nwinner: [o]"
        ]
      ),
      ( "complex unfinished game",
        [ "+-----------+",
          "| | | |o| | |",
          "| | | |x| | |",
          "| | | |o| | |",
          "| | |x|x| |o|",
          "|x|o|o|x| |x|",
          "|o|x|x|o|o|o|",
          "+-----------+",
          "Player x select your move:"
        ]
      ),
      ( "draw game",
        [ "+-----------+",
          "|o|x|o|x|o|x|",
          "|o|x|o|x|o|x|",
          "|x|o|x|o|x|o|",
          "|x|o|x|o|x|o|",
          "|o|x|o|x|o|x|",
          "|o|x|o|x|o|x|",
          "+-----------+",
          "Game Over\nIt's a draw"
        ]
      ),
      ("invalid move", ["Invalid move"]),
      ("game over move", ["Can't update finished game"])
    ]

prepareScreen = intercalate "\n"

assertExpectedScreen :: String -> String -> IO ()
assertExpectedScreen screenName actual =
  case M.lookup screenName screens of
    Nothing -> error $ "No such screen name - " ++ screenName
    Just expectedScreen ->
      assertEqual screenName (prepareScreen expectedScreen) actual
