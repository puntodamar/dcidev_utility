# Features

```ruby
# check if numeric value
DcidevUtility.is_numeric?(number)

# convert phone number prefixed with '+62' or '0'  to '62' format
# +628xxxxx --> 628xxxxx
DcidevUtility.phone_converter(phone)

# download file from url and save it as Tempfile
DcidevUtility.download_to_file(url)

# check if value is a phone number
DcidevUtility.is_phone_number?(phone)

# revert 62xx phone number format to 08xxx format
DcidevUtility.original_phone(phone)

# download file from url and return it as base64
# the returned value will be an array containing [extension, encoded_string, full_base64_string]
DcidevUtility.file_url_to_base64(url)

# check if base64
DcidevUtility.is_base64?(string)

# encode base64 to Tempfile
DcidevUtility.base64_to_file(string)

# check if url valid
DcidevUtility.url_exists?(url)

# extract dob from nik
DcidevUtility.dob_from_nik(nik)

# extract gender from nik
DcidevUtility.gender_from_nik(nik)

# convert integer value to formatted string currency
DcidevUtility.currency_formatter(amount, unit: "Rp. ", separator: ".", delimiter: ".", precision: 0)

# extract encoded string from base64
DcidevUtility.base64_encoded_string(base64)

# extract extension from base64
DcidevUtility.base64_extension(base64)

# mask a string
DcidevUtility.string_masking(string, length = 9)

DcidevUtility.response_simplifier(response)

# takeout base64 string from json hash
DcidevUtility.json_simplifier(json)
```
