import Control.Exception (evaluate)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Prelude.head" $ do
    it "returns the first element of a list" $ do
      let actual = head [5 ..]
          expected = 5
      head [23 ..] `shouldBe` 23

    it "throws an exception if used with an empty list" $ do
      evaluate (head []) `shouldThrow` anyException
