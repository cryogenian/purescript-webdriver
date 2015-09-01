module Selenium.XHR where

import Prelude
import Data.Maybe (Maybe())
import Data.Either (either, Either(..))
import Data.Traversable (for)
import Selenium (executeStr)
import Selenium.Types
import Control.Monad.Aff (Aff())
import Control.Monad.Error.Class (throwError)
import Control.Monad.Eff.Exception (error)
import Data.Foreign (readBoolean, isUndefined, readArray)
import Data.Foreign.Class (readProp)
import Data.Foreign.NullOrUndefined (runNullOrUndefined)


type XHRStats =
  { method :: String
  , url :: String
  , async :: Boolean
  , user :: Maybe String
  , password :: Maybe String
  , state :: String
  } 

startSpying :: forall e. Driver -> Aff (selenium :: SELENIUM|e) Unit
startSpying driver = void $ 
  executeStr driver """
"use strict"

var Selenium = {
    log: [],
    count: 0,
    spy: function() {
        var open = XMLHttpRequest.prototype.open;
        window.XMLHttpRequest.prototype.open =
            function(method, url, async, user, password) {
                this.__id = Selenium.count;
                Selenium.log[this.__id] = {
                    method: method,
                    url: url,
                    async: async,
                    user: user,
                    password: password,
                    state: "stale"
                };
                Selenium.count++;
                open.apply(this, arguments);
            };
        
        var send = XMLHttpRequest.prototype.send;
        window.XMLHttpRequest.prototype.send =
            function(data) {
                if (Selenium.log[this.__id]) {
                    Selenium.log[this.__id].state = "opened";
                }
                var m = this.onload;
                this.onload = function() {
                    if (Selenium.log[this.__id]) {
                        Selenium.log[this.__id].state = "loaded";
                    }
                    if (typeof m == 'function') {
                        m();
                    }
                };
                send.apply(this, arguments);
            };
        var abort = window.XMLHttpRequest.prototype.abort;
        window.XMLHttpRequest.prototype.abort = function() {
            if (Selenium.log[this.__id]) {
                Selenium.log[this.__id].state = "aborted";
            }
            abort.apply(this, arguments);
        };
        Selenium.unspy = function() {
            window.XMLHttpRequest.send = send;
            window.XMLHttpRequest.open = open;
            window.XMLHttpRequest.abort = abort;
        };
    },
    clean: function() {
        this.log = [];
        this.count = 0;
    }
};
window.__SELENIUM__ = Selenium;
Selenium.spy();
"""

stopSpying :: forall e. Driver -> Aff (selenium :: SELENIUM|e) Unit
stopSpying driver = void $ executeStr driver """
if (window.__SELENIUM__) {
    window.__SELENIUM__.unspy();
}
"""

clearLog :: forall e. Driver -> Aff (selenium :: SELENIUM|e) Unit 
clearLog driver = do 
  success <- executeStr driver """
  if (!window.__SELENIUM__) {
    return false;
  }
  else {
    window.__SELENIUM__.clean();
    return true;
  }
  """
  case readBoolean success of
    Right true -> pure unit
    _ -> throwError $ error "spying is inactive"

getStats :: forall e. Driver -> Aff (selenium :: SELENIUM|e) (Array XHRStats)
getStats driver = do 
  log <- executeStr driver """
  if (!window.__SELENIUM__) {
    return undefined;
  }
  else {
    return window.__SELENIUM__.log;
  }
  """
  if isUndefined log
    then throwError $ error "spying is inactive"
    else pure unit
  either (const $ throwError $ error "incorrect log") pure do
    arr <- readArray log
    for arr \el -> do
      state <- readProp "state" el
      method <- readProp "method" el
      url <- readProp "url" el
      async <- readProp "async" el
      password <- runNullOrUndefined <$> readProp "password" el
      user <- runNullOrUndefined <$> readProp "user" el
      pure { state: state
           , method: method
           , url: url
           , async: async
           , password: password
           , user: user
           }
  


