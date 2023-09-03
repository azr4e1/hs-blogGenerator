import qualified Convert
import qualified Markup
import qualified Html
import System.Directory (doesFileExist)
import System.Environment (getArgs)

confirm :: IO Bool
confirm =
    putStr "The output file already exist. Are you sure you want to overwrite it? (y/n): " *>
        getLine >>= \answer ->
            case answer of
                "y" -> pure True
                "n" -> pure False
                _ ->
                    putStrLn "Invalid response. Use y or n" *>
                    confirm

whenIO :: IO Bool -> IO () -> IO ()
whenIO cond action =
    cond >>= \result ->
        if result
            then action
            else pure ()

readWriteParsedContent :: FilePath -> FilePath -> IO ()
readWriteParsedContent input output =
    readFile input >>= \content ->
        whenIO (doesFileExist output >>= \result -> if result then confirm else pure True) .
            writeFile output .
            Convert.process input $
            content

main :: IO ()
main =
    getArgs >>=
    \arguments ->
        case arguments of
            [] -> getContents >>= print . Convert.process "Standard Input"
            [input] -> 
                doesFileExist input >>=
                    \result ->
                        readFile input >>= \content -> 
                            if result then print . Convert.process input $ content
                                      else putStrLn "The input file provided does not exist."
            [input, output] ->
                doesFileExist input >>=
                    \result -> if result then readWriteParsedContent input output
                                         else putStrLn "The input file provided does not exist."
            _ -> putStrLn "Usage: runghc Main.hs [-- <input-file> <output-file>]"
