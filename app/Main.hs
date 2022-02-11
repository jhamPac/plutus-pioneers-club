{-# LANGUAGE DeriveGeneric #-}

module Main (main) where

import           Blockfrost.Client
import qualified Data.Text         as T

main :: IO ()
main =  do
    project <- projectFromFile ".env"
    result <- runBlockfrost project $ do
                    r <- getAssetsByPolicy "c364930bd612f42e14d156e1c5410511e77f64cab8f2367a9df544d1"
                    case r of
                        (_:y:_) -> do
                            details <- getAssetDetails $ AssetId (_assetInfoAsset y)
                            case _assetDetailsOnchainMetadata details of
                                Nothing -> return ("Nah" :: T.Text)
                                Just d  -> return (_assetOnChainMetadataName d)
                        _       -> return "Not enough assets"

    case result of
        Left e  -> print e
        Right t -> print t



-- main = scotty 3000 $ do
--     get "/hello/:name" $ do
--         n <- param "name"
--         text $ mconcat ["Hello ", n, "!"]

--     get "/users/:id" $ do
--         i <- param "id"
--         json (filter (\user -> userId user == i) users)
