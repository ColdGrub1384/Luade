#  sharesheet

This module is used for acessing data trough the iOS share sheet and for sharing items. Place a script in the 'Share Sheet' folder to show it on the share sheet. With your scripts, you can share text, URLs and files.

## Retrieving passed data

## `string`
`sharesheet.string()`

Returns a string passed to the script.

## `url`
`sharesheet.url()`

Returns an URL passed to the script. (As a String)

## `filePath`
`sharesheet.filePath()`

Returns the path of a file passed to the script.

## Sharing data

## `shareItems`
`sharesheet.shareItems(items...)`

Opens the share sheet for sharing the given items.
Each parameter passed will be a shared items. Example:

    sharesheet.shareItems("Hello World!", "https://develobile.com")
