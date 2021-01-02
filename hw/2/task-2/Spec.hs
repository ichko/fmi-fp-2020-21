import ParserUtils
import Test.HUnit
import XMLParser

assertXMLFileParse :: String -> Test
assertXMLFileParse fileName = TestCase $ do
  actualContent <- readFile $ "test-files/" ++ fileName ++ ".xml"
  expectedContent <- readFile $ "test-files/" ++ fileName ++ ".obj"
  let eitherActual = runParser xmlParser actualContent
      readExpectedContent = reads expectedContent :: [(XMLObject, String)]

  case eitherActual of
    Left message -> error $ show message
    Right (_, actual) ->
      case readExpectedContent of
        [] -> error $ "could not read actual file " ++ fileName ++ ".obj"
        [(expected, _)] ->
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
