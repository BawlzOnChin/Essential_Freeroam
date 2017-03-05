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
