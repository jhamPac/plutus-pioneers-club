{-# LANGUAGE DeriveGeneric #-}

module Main (main) where

import           Blockfrost.Client
import           Data.Aeson        (FromJSON, ToJSON)
import qualified Data.Text         as T
import           GHC.Generics
import           Web.Scotty

data User = User {
        userId   :: Int,
        userName :: String
    } deriving (Generic, Show)

instance FromJSON User
instance ToJSON User

main :: IO ()
main = scotty 3000 $ do
    get "/hello/:name" $ do
        n <- param "name"
        text $ mconcat ["Hello ", n, "!"]

call = do
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
    BlockfrostFatal t           -> t
    BlockfrostNotFound          -> "Not found"
    BlockfrostIPBanned          -> "IP Banned"
    BlockfrostUsageLimitReached -> "Limit Reached"
    _                           -> "Client error"
