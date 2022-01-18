{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import           Blockfrost.Client
import           RIO


main :: IO ()
main = do
  p <- projectFromFile ".env"
  res <- runBlockfrost p $ do
    latestBlocks <- getLatestBlock
    pure (Right latestBlocks)

  case res of
    Right e ->
      case e of
        Right b -> runSimpleApp $ logInfo $ display $ _blockSlotLeader b
        _       -> runSimpleApp $ logInfo "again"
    _       -> runSimpleApp $ logInfo "ok"




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
