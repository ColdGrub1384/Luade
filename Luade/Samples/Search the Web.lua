-- This example shows how opening an URL.

io.write("Type to search on Google: ")
query = io.read()

function urlencode(str) -- Taken from https://gist.github.com/sysnajar/879e92b1ceab1b09dc65
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
    function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
    end
  return str
end

googleURL = "https://www.google.com/search?q="..urlencode(query)

openURL(googleURL)
