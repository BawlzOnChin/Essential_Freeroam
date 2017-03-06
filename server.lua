-- RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()

AddEventHandler('es:playerLoaded', function(source)
	-- Get the players money amount
TriggerEvent('es:getPlayerFromId', source, function(user)

TriggerClientEvent('es:activateMoney', source, tonumber(user.money))
TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your current cash balance is ~g~$".. tonumber(user.money))
	end)
end)
end)
