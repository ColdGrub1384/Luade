--[[
This script shows an example of how passing data from the iOS share sheet to scripts.
--]]

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
