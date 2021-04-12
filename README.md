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

## Usage Manual 

This guide assumes you're using the `android` layer.

### Generate the pre-translation CSV

* Run `bundle exec ruby universal_translator.rb -generate-android`
* Take the file in `untranslated_sheets/input_sheet_*.csv` into the Google Sheets step.

### Google Sheets Translation

1. Import the `input_sheet_1.csv` into a blank sheets page.
2. You can remove translations by just removing the row. It's fine if the input keys don't match the output keys exactly. The emojis you see are for newline preservation 😏.
3. Paste this formula in the empty cells to force a translation.

```
=GOOGLETRANSLATE($B2, "en", C$1)
```

Start at cell `C2` and just paste into the rest.
3. Export to a folder in this repo called "translated_sheets" with the filename "output_sheet_1.csv"

### Re-writing your translations

1. Download as CSV to `translated_sheets/output_sheet_1.csv`
2. Run `bundle exec ruby universal_translator.rb -apply-android`
3. Enjoy
