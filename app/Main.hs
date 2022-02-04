module Main (main) where

import           Blockfrost.Client
import qualified Data.Text         as T


main :: IO ()
main = do
  project <- projectFromFile ".env"
  result <- runBlockfrost project $ do
    latestBlocks <- getLatestBlock
    errors <- tryError $ getAccountRewards "Failed"
    pure (latestBlocks, errors)

  case result of
    Left bfe     -> print $ handleError bfe
    Right (b, _) -> print $ _blockSlotLeader b


handleError :: BlockfrostError -> T.Text
handleError b = case b of
  BlockfrostError t           -> t
  BlockfrostBadRequest t      -> t
  BlockfrostTokenMissing t    -> t
  BlockfrostNotFound          -> "Not found"
  BlockfrostIPBanned          -> "IP Banned"
  BlockfrostUsageLimitReached -> "Limit Reached"
  BlockfrostFatal t           -> t
  _                           -> "Client error"




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
