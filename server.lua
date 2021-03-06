local permission = {
	default = 0,
	staff = 1,
	admin = 2
}

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	-- Spawn the player at: X: 464.091, Y: -997.166, Z: 24.915
	TriggerClientEvent('es_freeroam:spawnPlayer', source, 464.091, -997.166, 24.915)
end)


AddEventHandler('es:playerLoaded', function(source)
	-- Get the players money amount
TriggerEvent('es:getPlayerFromId', source, function(user)
TriggerClientEvent('es:activateMoney', source, tonumber(user.money))
TriggerClientEvent('chatMessage', source, "SYSTEM", {187, 235, 42}, "Your money amount is: $" .. tonumber(user.money))
	end)
end)

--Help Commands
TriggerEvent('es:addCommand', 'help', function(source, args, user)
    TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/911 <message> - to call 911")
    TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/report <message> - to report a player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/admin to show your level")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/adminhelp to show admin commands")
end)

TriggerEvent('es:addCommand', 'adminhelp', function(source, args, user)
    TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/dispatch <message> - to respond as dispatcher")
    TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/slap <id> - to slap someone DO NOT ABUSE")
    TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/freeze <id> - to freeze someone")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/goto <id> - to teleport to someone")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/bring <id> - to teleport someone to you")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/kick <id> - to kick a player")
end)

-- 911 DISPATCHER
TriggerEvent('es:addAdminCommand', 'dispatch', permission.staff, function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "^5[911]", {30, 144, 255}, " (^1 Dispatcher: ^3" .. GetPlayerName(source) .." | "..source.."^0 ) " .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- 911 CALL
TriggerEvent('es:addAdminCommand', '911', permission.default, function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "^5[911]", {30, 144, 255}, " (^1 Caller ID: ^3" .. GetPlayerName(source) .." | "..source.."^0 ) " .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
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
			    TriggerClientEvent("es_freeroam:displaytext", source, "Your money has been set to $" .. tonumber(args[3]), 5000)
						-- TriggerClientEvent('chatMessage', tonumber(args[2]), "SYSTEM", {187, 235, 42}, "Your money has been set to: $" .. tonumber(args[3]))
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
