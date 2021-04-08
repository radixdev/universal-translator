# universal-translator
NCC 1701 communication tool

## configuration

Create a root level `config.json` file:
```
  {
    "locales" : [
      "fr", 
      {"lang": "es", "region": "ES"}
    ],
    "layers" : {
      "android": {
        "path" : "/Users/juliancontreras/awesome-app/src/main/res/"
      }
    }
  }
```
