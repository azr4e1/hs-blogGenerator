module OptParse
    ( Options(..),
      SingleInput(..),
      SingleOutput(..),
      parse
    )
where

import Data.Maybe (fromMaybe)
import Options.Applicative
import Control.Applicative (optional)

data Options = ConvertSingle SingleInput SingleOutput
             | ConvertDir FilePath FilePath
             deriving Show

data SingleInput = Stdin
                 | InputFile FilePath
                 deriving Show

data SingleOutput = Stdout
                  | OutputFile FilePath
                  deriving Show

pInputFile :: Parser SingleInput
pInputFile = fmap InputFile parser
    where parser = strOption ( long "input"
                               <> short 'i'
                               <> metavar "FILE"
                               <> help "Input file")

pOutputFile :: Parser SingleOutput
pOutputFile = fmap OutputFile parser
    where parser = strOption ( long "output"
                               <> short 'o'
                               <> metavar "FILE"
                               <> help "Output file")

-- pConvertSingle :: Parser Options
-- pConvertSingle =
--     liftA2 ConvertSingle pInputFile pOutputFile

pInputDir :: Parser FilePath
pInputDir =
    strOption
        ( long "input"
          <> short 'i'
          <> metavar "DIRECTORY"
          <> help "Input directory")

pOutputDir :: Parser FilePath
pOutputDir =
    strOption
        ( long "output"
          <> short 'o'
          <> metavar "DIRECTORY"
          <> help "Output directory")

pConvertDir :: Parser Options
pConvertDir =
    ConvertDir <$> pInputDir <*> pOutputDir

pSingleInput :: Parser SingleInput
pSingleInput =
    fromMaybe Stdin <$> optional pInputFile

pSingleOutput :: Parser SingleOutput
pSingleOutput =
    fromMaybe Stdout <$> optional pOutputFile

pConvertSingle :: Parser Options
pConvertSingle =
    ConvertSingle <$> pSingleInput <*> pSingleOutput

pConvertSingleInfo :: ParserInfo Options
pConvertSingleInfo =
    info
        (helper <*> pConvertSingle)
        (progDesc "Convert a single markup source to html")

pConvertSingleCommand :: Mod CommandFields Options
pConvertSingleCommand =
    command "convert" pConvertSingleInfo

pOptions :: Parser Options
pOptions =
    subparser
        ( command
          "convert"
          ( info 
            (helper <*> pConvertSingle)
            (progDesc "Convert a single markup source to html")
          )
          <> command
          "convert-dir"
          ( info
            (helper <*> pConvertDir)
            (progDesc "Convert a directory of markup files to html")
          )
        )

opts :: ParserInfo Options
opts =
    info (helper <*> pOptions)
        ( fullDesc
          <> header "hs-blog-gen - a static blog generator"
          <> progDesc "Convert markup files or directories to html"
        )

parse :: IO Options
parse = execParser opts
