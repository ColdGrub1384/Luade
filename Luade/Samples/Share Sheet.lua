-- This script shows an example of how passing data from the iOS share sheet to scripts.

-- With Luade, you can share text, URLs and files with your scripts.

-- For that, just create a script the the "Share Sheet" directory. Then, when you share a text, an URL or a file, you can select 'Run Lua Script' and select the script you created.

-- You can test this example from the Share Sheet.

str = sharesheet.string() -- Text
url = sharesheet.url() -- URL
filePath = sharesheet.filePath() -- File Path

if str ~= nil then
    print("String: "..str) -- Text is found
elseif url ~= nil then
    print("URL: "..url) -- URL is found
elseif filePath ~= nil then
    print("File Path: "..filePath) -- File is found
else
    print("No item found") -- No item found
end
