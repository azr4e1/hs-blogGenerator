import qualified Convert
import qualified Markup
import qualified Html
import System.Directory (doesFileExist)
import System.Environment (getArgs)

confirm :: IO Bool
confirm = do
    putStr "The output file already exist. Are you sure you want to overwrite it? (y/n): "
    answer <- getLine
    case answer of
        "y" -> pure True
        "n" -> pure False
        _ ->
            putStrLn "Invalid response. Use y or n" *>
            confirm
    
whenIO :: IO Bool -> IO () -> IO ()
whenIO cond action = do
    result <- cond
    if result
        then action
        else pure ()

readWriteParsedContent :: FilePath -> FilePath -> IO ()
readWriteParsedContent input output = do
    content <- readFile input
    outputExists <- doesFileExist output
    whenIO (if outputExists then confirm else pure True) .
        writeFile output .
        Convert.process input $
        content

main :: IO ()
main = do
    arguments <- getArgs
    case arguments of
        [] -> do
            content <- getContents
            print . Convert.process "Standard Input" $ content
        [input] -> do
            inputExists <- doesFileExist input
            if inputExists then do
                content <- readFile input
                print . Convert.process input $ content
            else putStrLn "The input file provided does not exist."
        [input, output] -> do
            inputExists <- doesFileExist input
            if inputExists then readWriteParsedContent input output
            else putStrLn "The input file provided does not exist."
        _ -> putStrLn "Usage: runghc Main.hs [-- <input-file> <output-file>]"

