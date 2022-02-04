{-# OPTIONS_GHC -F -pgmF hspec-discover #-}

module Spec where
import           Test.Hspec
import           Test.Hspec.QuickCheck

spec :: Spec
spec = do
    describe "plus2" $ do
        it "basic check" $ 2 `shouldBe` 2
