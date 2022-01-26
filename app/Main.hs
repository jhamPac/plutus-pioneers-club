{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import           Blockfrost.Client
import           RIO
import           RIO.List.Partial


main :: IO ()
main = do
  p <- projectFromFile ".env"
  res <- runBlockfrost p $ do
    latestBlocks <- getLatestBlock
    ers <- tryError $ getAccountRewards "Failed"
    pure (latestBlocks, ers)

  case res of
    Right e ->
      case e of
        (b, _) -> runSimpleApp $ logInfo $ display $ _blockSlotLeader b
        (_, x) ->
          case x of
            Right a -> runSimpleApp $ logInfo $ display $ unPoolId $ _accountRewardPoolId $ head a
            Left (BlockfrostError y)  -> runSimpleApp $ logInfo $ display $ y
    _ -> runSimpleApp $ logInfo "Fail"




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
