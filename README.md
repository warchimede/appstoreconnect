# appstoreconnect

[![License](https://img.shields.io/github/license/warchimede/appstoreconnect)](https://github.com/warchimede/appstoreconnect)

## Summary

A Swift command line tool to interact with the [App Store Connect API](https://developer.apple.com/app-store-connect/api/).

## Installation

1. Clone this repo
2. Execute `make` (it basically builds the executable and puts it in `/usr/local/bin`)

## Requirements

### macOS 10.15 (Catalina)

### Generate the App Store Connect API private key

According to the [official Apple documentation](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api):
> To generate keys, you must have an Admin account in App Store Connect. You may generate multiple API keys with any roles you choose.
> 1. To generate an API key to use with the App Store Connect API, log in to App Store Connect.
> 2. Select Users and Access, and then select the API Keys tab.
> 3. Click Generate API Key or the Add (+) button.
> 4. Enter a name for the key. The name is for your reference only and is not part of the key itself.
> 5. Under Access, select the role for the key.
> 6. Click Generate.
> 7. The new key's name, key ID, a download link, and other information appears on the page.

Name you key `App Store Connect API key`, download it and persist it somewhere safe.
It should be a `AuthKey_<key_id>.p8` file.

Also, remember the key identifier and your `Issuer ID` for later use.

### Store the key at the right location

Then, store a copy of your private API key under the path `~/.appstoreconnect/private_keys/`.
This step is very important for `appstoreconnect` to locate your API key.

## Usage

Here's the general command line help:
```
OVERVIEW: An interface for the App Store Connect API

USAGE: appstoreconnect <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  profiles                Download and install the provisioning profiles
  users                   Print the users

  See 'appstoreconnect help <subcommand>' for detailed help.
```

And for instance, for the `profiles` subcommand:
```
OVERVIEW: Download and install the provisioning profiles

USAGE: appstoreconnect profiles <key-id> <iss-id>

ARGUMENTS:
  <key-id>                The key identifier
  <iss-id>                The issuer identifier

OPTIONS:
  -h, --help              Show help information.
```

## Dependencies

- [Swift Argument Parser](https://github.com/apple/swift-argument-parser) from Apple
- [Swift Crypto](https://github.com/apple/swift-crypto) from Apple
- [JWTKit](https://github.com/vapor/jwt-kit) from Vapor

## Author

[William Archimede](http://twitter.com/warchimede)

## License
`appstoreconnect` is available under the MIT License.

If you use it and like it, let me know: [@warchimede](http://twitter.com/warchimede)