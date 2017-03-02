local permission = {
	default = 0,
	staff = 1
	admin = 2
}

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	-- Spawn the player at: X:436.491 Y: -982.172 Z:30.699
	TriggerClientEvent('es_freeroam:spawnPlayer', source, 436.491, -982.172, 30.699)
end)


AddEventHandler('es:playerLoaded', function(source)
	-- Money Management
TriggerEvent('es:getPlayerFromId', source, function(user)
TriggerClientEvent('es:activateMoney', source, tonumber(user.money))
TriggerClientEvent('chatMessage', source, "SYSTEM", {187, 235, 42}, "Your money amount is: $" .. tonumber(user.money))
	end)
end)


-- Set money to the players account
TriggerEvent('es:addAdminCommand', 'setmoney', permission.admin, function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You're not allowed to target this person!")
					return
				end

				TriggerEvent("es:setPlayerData", tonumber(args[2]), "money", tonumber(args[3]), function(response, success)

					TriggerClientEvent('es:activateMoney', tonumber(args[2]), tonumber(args[3]))

					if(success)then
						TriggerClientEvent('chatMessage', tonumber(args[2]), "SYSTEM", {187, 235, 42}, "Your money has been set to: $" .. tonumber(args[3]))
					end
				end)

			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)


-- Kicking
TriggerEvent('es:addAdminCommand', 'kick', permission.staff, function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You're not allowed to target this person!")
					return
				end

				local reason = args
				table.remove(reason, 1)
				table.remove(reason, 1)
				if(#reason == 0)then
					reason = "Kicked: You have been kicked from the server"
				else
					reason = "Kicked: " .. table.concat(reason, " ")
				end

				TriggerClientEvent('chatMessage', -1, "SYSTEM", {187, 235, 42}, "Player ^2" .. GetPlayerName(player) .. "^0 has been kicked(^2" .. reason .. "^0)")
				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
 end
   function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)
