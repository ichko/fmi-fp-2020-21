import ParserUtils
import Test.HUnit
import XMLParser

assertXMLFileParse :: String -> Test
assertXMLFileParse fileName = TestCase $ do
  expectedContent <- readFile $ "test-files/" ++ fileName ++ ".xml"
  actualContent <- readFile $ "test-files/" ++ fileName ++ ".obj"
  let eitherExpected = runParser xmlParser expectedContent
      readActualContent = reads actualContent :: [(XMLObject, String)]

  case eitherExpected of
    Left message -> error $ show message
    Right (_, expected) ->
      case readActualContent of
        [] -> error $ "could not read actual file " ++ fileName ++ ".obj"
        [(actual, _)] ->
          assertEqual
            ("'" ++ fileName ++ "' files should be equal")
            expected
            actual

-- Example XML SRC - https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ms762271(v=vs.85)

tests :: Test
tests =
  TestList $
    map assertXMLFileParse ["a", "b", "c", "d"]

main :: IO Counts
main = runTestTT tests
