#  pasteboard

This module is used for copy and pasting data.

## Retrieving text

## `string`
`pasteboard.string()`

Returns the copied text.

## `strings`
`pasteboard.strings()`

Returns the copied texts.

## Setting text

## `setString`
`pasteboard.setString(string)`

Copies the given string.

## `setStrings`
`pasteboard.setStrings(strings...)`

Copies the given strings.

Each parameter passed will be copied. Example:

    pasteboard.copy("Hello World!", "Bye!")


