-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)


  AddEventHandler("playerSpawned", function(spawn)
    -- Send notifications
    Citizen.CreateThread(function()
    while true do
      Wait(0)
      SetNotificationTextEntry("STRING");
      AddTextComponentString("Use /help to view all available commands.\n ~y~For more info go to github.com/FiveM-Scripts");
      SetNotificationMessage("CHAR_ALL_PLAYERS_CONF", "CHAR_ALL_PLAYERS_CONF", true, 1, "Essential Freeroam", "v0.1.1");
      DrawNotification(false, true);
      Wait(500000)
    end

    local playerPed = GetPlayerPed(-1);
    if (IsPedModel(playerPed, GetHashKey("player_zero"))) then
			model = 0
		elseif (IsPedModel(playerPed, GetHashKey("player_one"))) then
			model = 1
		elseif (IsPedModel(playerPed, GetHashKey("player_two"))) then
			model = 2
		end
		local statname = "SP"..model.."_TOTAL_CASH"
		local hash = GetHashKey(statname)
		local bool, val = StatGetInt(hash, 0, -1)
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
