## Module Selenium.Types

#### `Builder`

``` purescript
data Builder :: *
```

#### `SELENIUM`

``` purescript
data SELENIUM :: !
```

#### `Driver`

``` purescript
data Driver :: *
```

#### `Until`

``` purescript
data Until :: *
```

#### `Element`

``` purescript
data Element :: *
```

#### `Locator`

``` purescript
data Locator :: *
```

#### `ActionSequence`

``` purescript
data ActionSequence :: *
```

#### `MouseButton`

``` purescript
data MouseButton :: *
```

#### `ChromeOptions`

``` purescript
data ChromeOptions :: *
```

#### `ControlFlow`

``` purescript
data ControlFlow :: *
```

#### `FirefoxOptions`

``` purescript
data FirefoxOptions :: *
```

#### `IEOptions`

``` purescript
data IEOptions :: *
```

#### `LoggingPrefs`

``` purescript
data LoggingPrefs :: *
```

#### `OperaOptions`

``` purescript
data OperaOptions :: *
```

#### `ProxyConfig`

``` purescript
data ProxyConfig :: *
```

#### `SafariOptions`

``` purescript
data SafariOptions :: *
```

#### `ScrollBehaviour`

``` purescript
data ScrollBehaviour :: *
```

#### `Capabilities`

``` purescript
data Capabilities :: *
```

#### `FileDetector`

``` purescript
data FileDetector :: *
```

#### `Method`

``` purescript
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
```

Copied from `purescript-affjax` because the only thing we
need from `affjax` is `Method`                    

##### Instances
``` purescript
instance methodIsForeign :: IsForeign Method
```

#### `Location`

``` purescript
type Location = { x :: Number, y :: Number }
```

#### `ControlKey`

``` purescript
newtype ControlKey
  = ControlKey String
```


