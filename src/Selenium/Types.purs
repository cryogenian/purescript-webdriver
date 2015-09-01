module Selenium.Types where

import Prelude
import Data.Foreign.Class (IsForeign)
import Data.Foreign (readString)
import Data.String (toLower)

foreign import data Builder :: *
foreign import data SELENIUM :: !
foreign import data Driver :: *
foreign import data Until :: *
foreign import data Element :: *
foreign import data Locator :: *
foreign import data ActionSequence :: *
foreign import data MouseButton :: *
foreign import data ChromeOptions :: *
foreign import data ControlFlow :: *
foreign import data FirefoxOptions :: *
foreign import data IEOptions :: *
foreign import data LoggingPrefs :: *
foreign import data OperaOptions :: *
foreign import data ProxyConfig :: *
foreign import data SafariOptions :: *
foreign import data ScrollBehaviour :: *
foreign import data Capabilities :: *
foreign import data FileDetector :: *

-- | Copied from `purescript-affjax` because the only thing we
-- | need from `affjax` is `Method`                    
data Method
  = DELETE
  | GET
  | HEAD
  | OPTIONS
  | PATCH
  | POST
  | PUT
  | MOVE
  | COPY
  | CustomMethod String


instance methodIsForeign :: IsForeign Method where
  read f = do
    str <- readString f
    pure $ case toLower str of
      "delete" -> DELETE
      "get" -> GET
      "head" -> HEAD
      "options" -> OPTIONS
      "patch" -> PATCH
      "post" -> POST
      "put" -> PUT
      "move" -> MOVE
      "copy" -> COPY
      a -> CustomMethod a 
      


type Location =
  { x :: Number
  , y :: Number
  }

newtype ControlKey = ControlKey String
