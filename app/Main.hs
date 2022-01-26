{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import           Blockfrost.Client
import           RIO


main :: IO ()
main = do
  p <- projectFromFile ".env"
  res <- runBlockfrost p $ do
    latestBlocks <- getLatestBlock
    ers <- tryError $ getAccountRewards "Failed"
    pure (latestBlocks, ers)

  case res of
    Left bfe     -> runSimpleApp $ logInfo $ handleError bfe
    Right (b, _) -> runSimpleApp $ logInfo $ display $ _blockSlotLeader b


handleError :: BlockfrostError -> Utf8Builder
handleError b = case b of
  BlockfrostError t           -> display t
  BlockfrostBadRequest t      -> display t
  BlockfrostTokenMissing t    -> display t
  BlockfrostNotFound          -> display ("Not found" :: Text)
  BlockfrostIPBanned          -> display ("IP Banned" :: Text)
  BlockfrostUsageLimitReached -> display ("Limit Reached" :: Text)
  BlockfrostFatal t           -> display t
  _                           -> display ("Client error" :: Text)



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
