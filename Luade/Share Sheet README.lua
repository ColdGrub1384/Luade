--[[
With Luade, you can share text, URLs and files with your scripts.

For that, just create a script IN THIS DIRECTORY. Then, when you share a text, an URL or a file, you can select 'Run Lua Script' and select the script you created.
--]]

sharesheet.string() -- Retrieves text
sharesheet.url() -- Retrieves an URL
sharesheet.filePath() -- Retrieves the path of a file

-- One of the previous functions should return something depending on what you shared. They will return `nil` if the script is ran from the app.

