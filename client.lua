local states = {}
states.frozen = false
states.frozenPos = nil

-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()

    exports.spawnmanager:setAutoSpawnCallback(function()
        if spawnLock then
            return
        end

      --  spawnLock = true

        TriggerServerEvent('playerSpawn')
        TriggerEvent('playerSpawn')
    end)
end)

-- Allows the server to spawn the player
RegisterNetEvent('es_freeroam:spawnPlayer')
AddEventHandler('es_freeroam:spawnPlayer', function(x, y, z, model)
    exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = model})
  end)

  AddEventHandler("playerSpawned", function(spawn)
    Citizen.CreateThread(function()
    while true do
      Wait(0)
      SetNotificationTextEntry("STRING");
      AddTextComponentString("Use /help to view all available commands.\n ~y~For more info go to github.com/FiveM-Scripts");
      SetNotificationMessage("CHAR_ALL_PLAYERS_CONF", "CHAR_ALL_PLAYERS_CONF", true, 1, "Essential Freeroam", "v0.1.1");
      DrawNotification(false, true);
      Wait(500000)
    end
   end)

  -- Give dead peds money to pickup
   Citizen.CreateThread(function()
	while true do
		Wait(0)
		   local pos = GetEntityCoords(GetPlayerPed(-1));
			 local cashped = GetRandomPedAtCoord(pos['x'], pos['y'], pos['z'], 9.0, 9.0, 9.0,9.0, 26);
			 if  cashped ~= nil and DoesEntityExist(cashped) then
				 SetEntityAsMissionEntity(cashped,0,0);
				 FreezeEntityPosition(cashped,0);
				 SetPedMoney(cashped, GetRandomIntInRange(10, 100));

			 if IsPedFatallyInjured(cashped) then
					CreateMoneyPickups(cashped.x+50.0, cashped.y+50.0, cashped.z+5.0, cMoney, 4, 0x684a97ae);
					SetEntityAsNoLongerNeeded(cashped);
			 end

		end
	end
end)
  end)


  -- Display text
    RegisterNetEvent("es_freeroam:displaytext")
    AddEventHandler("es_freeroam:displaytext", function(text, time)
    	ClearPrints()
    	SetTextEntry_2("STRING")
    	AddTextComponentString(text)
    	DrawSubtitleTimed(time, 1)
    end)

    -- Display notification
RegisterNetEvent("es_freeroam:notify")
AddEventHandler("es_freeroam:notify", function(icon, type, sender, title, text)
  Citizen.CreateThread(function()
  Wait(1)
  SetNotificationTextEntry("STRING");
  AddTextComponentString(text);
  SetNotificationMessage(icon, icon, true, type, sender, title, text);
  DrawNotification(false, true);
 end)
end)

-- Freeze Player
RegisterNetEvent('es_freeroam:freezePlayer')
AddEventHandler("es_freeroam:freezePlayer", function(state)
	local player = PlayerId()

	local ped = GetPlayerPed(-1)

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
			if not IsEntityVisible(ped) then
					SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
					SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			--SetCharNeverTargetted(ped, false)
			SetPlayerInvincible(player, false)
	else

			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			--SetCharNeverTargetted(ped, true)
			SetPlayerInvincible(player, true)
			--RemovePtfxFromPed(ped)

			if not IsPedFatallyInjured(ped) then
					ClearPedTasksImmediately(ped)
			end
	end
end)

-- Teleport
RegisterNetEvent('es_freeroam:teleportUser')
AddEventHandler('es_freeroam:teleportUser', function(user)
	local pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(user))))
	SetEntityCoords(GetPlayerPed(-1), pos)
	states.frozenPos = pos
end)

-- Slap
RegisterNetEvent('es_freeroam:slap')
AddEventHandler('es_freeroam:slap', function()
	local ped = GetPlayerPed(-1)

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

-- Give Position
RegisterNetEvent('es_freeroam:givePosition')
AddEventHandler('es_freeroam:givePosition', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local string = "{ ['x'] = " .. pos.x .. ", ['y'] = " .. pos.y .. ", ['z'] = " .. pos.z .. " },\n"
	TriggerServerEvent('es_freeroam:givePos', string)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position saved to file.')
end)

-- Kill
RegisterNetEvent('es_freeroam:kill')
AddEventHandler('es_freeroam:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			SetEntityCoords(GetPlayerPed(-1), states.frozenPos)
		end
	end
end)