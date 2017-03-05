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

-- TriggerClientEvent('es:activateMoney', source, tonumber(user.money))
TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your current cash balance is ~g~$".. tonumber(user.money))
	end)
end)

--Help Commands
TriggerEvent('es:addCommand', 'help', function(source, args, user)
  TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/911 <message> - Call 911")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/cash - Get your current money balance")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/pay <id> <money> - Pay another player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/permissions - Check your permission level")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "-------------------------------------------------------")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/adminhelp to show admin and staff commands")
end)

TriggerEvent('es:addCommand', 'adminhelp', function(source, args, user)
  TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/dispatch <message> - Respond to the 911 call")
  TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/arrest <id> - Arrest the player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "-------------------------------------------------------")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/goto <id> -  Teleport to the player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/bring <id> - Teleport the player to you")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "-------------------------------------------------------")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/ban <id>  - Ban a player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/kick <id> - Kick a player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "-------------------------------------------------------")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/setmoney <id> <money> - Set the money amount for a player")
	TriggerClientEvent("chatMessage", source, "^1SYSTEM", {255, 255, 255}, "/addmoney <id> <money> - Give more money to the player")

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
	TriggerClientEvent("es_freeroam:notify", source, "CHAR_CALL911", 1, "911 Emergency", "Confirmation", "We received your call, an officer will arrive shortly")
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

TriggerEvent('es:addCommand', 'permission', function(source, args, user)
	local level = tonumber(user.permission_level)

				if(level == 0)then
					name = "Player"
				elseif(level == 1)then
					name = "Staff"
				elseif(level == 2)then
					name = "Administrator"
				end

	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Your permission level is: ^2" .. name)
end)

  TriggerEvent('es:addCommand', 'cash', function(source, args, user)
		TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your current cash is ~y~$".. tonumber(user.money))
			end)
	end)

	TriggerEvent('es:addCommand', 'pay', function(source, args, user)
     local player = tonumber(args[2])

		TriggerEvent('es:getPlayerFromId', source, function(user)
      -- Balance check
			if(tonumber(user.money) <= tonumber(args[3])) then
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "~r~You don't have enough money.");
				else
		totalPlayer = tonumber(user.money) - tonumber(args[3]);
  	TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", "Payment done", "Your money balance has been changed to ~y~$".. tonumber(totalPlayer))

		TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerEvent("es:setPlayerData", tonumber(args[2]), "money", tonumber(args[3]), function(response, success)
				if(success)then
					TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your just received ~g~$".. tonumber(args[3]) .. "\n")
				end
			end)
		end)
	 end
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
						TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your money has been set to ~g~$".. tonumber(args[3]))
			    -- TriggerClientEvent("es_freeroam:displaytext", source, "Your money has been set to ~g~$" .. tonumber(args[3]), 5000)
					end
				end)

			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Add more money to the players account
TriggerEvent('es:addAdminCommand', 'addmoney', permission.admin, function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You're not allowed to target this person!")
					return
				end

         total = tonumber(user.money) + tonumber(args[3]);
				TriggerEvent("es:setPlayerData", tonumber(args[2]), "money", tonumber(total), function(response, success)
					TriggerClientEvent('es:activateMoney', tonumber(args[2]), tonumber(total))
					if(success)then
					Wait(0)
					TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your money has been updated to ~g~$".. tonumber(total))
			    -- TriggerClientEvent("es_freeroam:displaytext", source, "Your money has been updated to ~g~$" .. tonumber(total), 5000)
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
