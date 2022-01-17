{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import           Blockfrost.Client
import           RIO

xyz :: IO Text
xyz = do
  p <- projectFromFile ".env"
  pure (projectId p)


main :: IO ()
main = do
  s <- xyz
  runSimpleApp $ logInfo $ display s

-- main :: IO ()
-- main = do
--   (options, ()) <- simpleOptions
--     $(simpleVersion Paths_blockfrost_excercise.version)
--     "Header for command line arguments"
--     "Program description, also for command line arguments"
--     (Options
--        <$> switch ( long "verbose"
--                  <> short 'v'
--                  <> help "Verbose output?"
--                   )
--     )
--     empty
--   lo <- logOptionsHandle stderr (optionsVerbose options)
--   pc <- mkDefaultProcessContext
--   withLogFunc lo $ \lf ->
--     let app = App
--           { appLogFunc = lf
--           , appProcessContext = pc
--           , appOptions = options
--           }
--      in runRIO app run
