module HsBlog
    ( convertSingle
    , convertDirectory
    , Convert.process
    , confirm
    )
where

import qualified HsBlog.Markup as Markup
import qualified HsBlog.Html as Html
import qualified HsBlog.Convert as Convert
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.IO

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

convertSingle :: Html.Title -> Handle -> Handle -> IO ()
convertSingle title input output = do
    content <- hGetContents input
    hPutStrLn output (Convert.process title content)

convertDirectory :: FilePath -> FilePath -> IO ()
convertDirectory = error "Not Implemented"

-- main :: IO ()
-- main = do
--     arguments <- getArgs
--     case arguments of
--         [] -> do
--             content <- getContents
--             print . Convert.process "Standard Input" $ content
--         [input] -> do
--             inputExists <- doesFileExist input
--             if inputExists then do
--                 content <- readFile input
--                 print . Convert.process input $ content
--             else putStrLn "The input file provided does not exist."
--         [input, output] -> do
--             inputExists <- doesFileExist input
--             if inputExists then readWriteParsedContent input output
--             else putStrLn "The input file provided does not exist."
--         _ -> putStrLn "Usage: runghc Main.hs [-- <input-file> <output-file>]"
