module Main (main) where

import           Blockfrost.Client
import qualified Data.Text         as T


main :: IO ()
main = do
  p <- projectFromFile ".env"
  res <- runBlockfrost p $ do
    latestBlocks <- getLatestBlock
    ers <- tryError $ getAccountRewards "Failed"
    pure (latestBlocks, ers)

  case res of
    Left bfe     -> print $ handleError bfe
    Right (b, _) -> print $ _blockSlotLeader b


handleError :: BlockfrostError -> T.Text
handleError b = case b of
  BlockfrostError t           -> t
  BlockfrostBadRequest t      -> t
  BlockfrostTokenMissing t    -> t
  BlockfrostNotFound          -> ("Not found" :: T.Text)
  BlockfrostIPBanned          -> ("IP Banned" :: T.Text)
  BlockfrostUsageLimitReached -> ("Limit Reached" :: T.Text)
  BlockfrostFatal t           -> t
  _                           -> ("Client error" :: T.Text)



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
