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

### Getting Existing Android configuration
`bundle exec ruby universal_translator.rb -read-existing-android`

This will print out the existing language translations for the project.

## Google Sheets

1. Import the `input_sheet_1.csv` into a blank sheets page.
2. Paste this formula in the empty cells to force a translation.

```
=GOOGLETRANSLATE($B5, "en", C$1)
```

3. Export to folder called "translated_sheets" with the filename "output_sheet_1.csv"
