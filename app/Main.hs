module Main (main) where

import           Blockfrost.Client (AssetDetails (_assetDetailsOnchainMetadata),
                                    AssetId (AssetId),
                                    AssetInfo (_assetInfoAsset),
                                    AssetOnChainMetadata (_assetOnChainMetadataName),
                                    getAssetDetails, getAssetsByPolicy,
                                    projectFromFile, runBlockfrost)
import qualified Data.Text         as T

main :: IO ()
main =  do
    project <- projectFromFile ".env"
    result <- runBlockfrost project $ do
                    r <- getAssetsByPolicy "c364930bd612f42e14d156e1c5410511e77f64cab8f2367a9df544d1"
                    if length r > 1
                        then
                            do
                                let a = r !! 1
                                details <- getAssetDetails $ AssetId (_assetInfoAsset a)
                                case _assetDetailsOnchainMetadata details of
                                    Nothing -> return ("No asset meta data" :: T.Text)
                                    Just d  -> return (_assetOnChainMetadataName d)

                        else return "Not enough assets"

    case result of
        Left e  -> print e
        Right t -> print t
