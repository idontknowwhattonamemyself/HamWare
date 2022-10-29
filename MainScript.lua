repeat task.wait() until game:IsLoaded()
function getfile(path)
    if shared["HamWareExternal"] then
        return readfile("HamWare/"..path)
    else
        return game:HttpGet("https://raw.githubusercontent.com/Ham-135/HamWare/main/"..path)
    end
end
local HamWare = {}
HamWare["Version"] = loadstring(getfile("Version.lua"))()
HamWare["IsFile"] = betterisfile
HamWare["GetFile"] = getfile
HamWare["SaveName"] = "Universal"
if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    HamWare["SaveName"] = "BWGame"
elseif game.PlaceId == 6872265039 then
    HamWare["SaveName"] = "BWLobby"
end
shared["HamWare"] = HamWare

if HamWare["SaveName"] == "BWGame" then
    loadstring(getfile("Modules/Bedwars.lua"))()
else
    local suc,err = pcall(function()
        loadstring(getfile("Modules/"..game.PlaceId..".lua"))
    end)
    if not suc then
        loadstring(getfile("Modules/Universal.lua"))()
    end
end
