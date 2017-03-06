function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Configure Store Locations
local blips = {
    {id=52, x=28.463, y=-1353.033, z=29.340},
    {id=52, x=-54.937, y=-1759.108, z=29.005},
    {id=52, x=375.858, y=320.097, z=103.433},
    {id=52, x=1143.813, y=-980.601, z=46.205},
    {id=52, x=1695.284, y=4932.052, z=42.078},
    {id=52, x=2686.051, y=3281.089, z=55.241},
    {id=52, x=1967.648, y=3735.871, z=32.221},
    {id=52, x=-2977.137, y=390.652, z=15.024},
    {id=52, x=1160.269, y=-333.137, z=68.783},
    {id=52, x=-1492.784, y=-386.306, z=39.798},
    {id=52, x=-1229.355, y=-899.230, z=12.263},
    {id=52, x=-712.091, y=-923.820, z=19.014},
    {id=52, x=-1816.544, y=782.072, z=137.600},
    {id=52, x=1729.689, y=6405.970, z=34.453},
    {id=52, x=2565.705, y=385.228, z=108.463},
  }

-- Configure the locations for peds
local peds = {
  {type=4, hash=0x18ce57d0, x=-46.313, y=-1757.504, z=29.421, a=46.395},
  {type=4, hash=0x18ce57d0, x=24.376, y=-1345.558, z=29.421, a=267.940},
  {type=4, hash=0x18ce57d0, x=1134.182, y=-982.477, z=46.416, a=275.432},
  {type=4, hash=0x18ce57d0, x=373.015, y=328.332, z=103.566, a=257.309},
  {type=4, hash=0x18ce57d0, x=2676.389, y=3280.362, z=55.241, a=332.305},
  {type=4, hash=0x18ce57d0, x=1958.960, y=3741.979, z=32.344, a=303.196},
  {type=4, hash=0x18ce57d0, x=-2966.391, y=391.324, z=15.043, a=88.867},
  {type=4, hash=0x18ce57d0, x=-1698.542, y=4922.583, z=42.064, a=324.021},
  {type=4, hash=0x18ce57d0, x=1164.565, y=-322.121, z=69.205, a=100.492},
  {type=4, hash=0x18ce57d0, x=-1486.530, y=-377.768, z=40.163, a=147.669},
  {type=4, hash=0x18ce57d0, x=-1221.568, y=-908.121, z=12.326, a=31.739},
  {type=4, hash=0x18ce57d0, x=-706.153, y=-913.464, z=19.216, a=82.056},
  {type=4, hash=0x18ce57d0, x=-1820.230, y=794.369, z=138.089, a=130.327},
  {type=4, hash=0x18ce57d0, x=2555.474, y=380.909, z=108.623, a=355.737},
  {type=4, hash=0x18ce57d0, x=1728.614, y=6416.729, z=35.037, a=247.369},
}

-- Function to display info
function ShowInfo(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

Citizen.CreateThread(function()

  -- Load the ped modal (mp_m_shopkeep_01)
  RequestModel(0x18ce57d0)
  while not HasModelLoaded(0x18ce57d0) do
    Wait(1)
  end

  -- Load the bouncer animation (testing)
  RequestAnimDict("amb@prop_human_bum_shopping_cart@male@idle_a")
  while not HasAnimDictLoaded("amb@prop_human_bum_shopping_cart@male@idle_a") do
    Wait(1)
  end

  -- Create blips on the map for all the stores
  for _, item in pairs(blips) do
    item.blip = AddBlipForCoord(item.x, item.y, item.z)
    SetBlipSprite(item.blip, item.id)
    SetBlipAsShortRange(item.blip, true)
  end

  -- Spawn the peds in the shops
  for _, item in pairs(peds) do
    ped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    TaskPlayAnim(ped,"amb@prop_human_bum_shopping_cart@male@idle_a","idle_a", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    Citizen.CreateThread(function()
      while true do
      Citizen.Wait(0)
      local playerPed = GetPlayerPed(-1)
      local playerCoords = GetEntityCoords(playerPed, true)
      local doordist = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, item.x, item.y, item.z, true)
      if doordist < 2 then
        ShowInfo("Press ~INPUT_CONTEXT~ to start shopping", 0)
      end
      
      if doordist < 2 and IsControlPressed(1, 51) then
  			PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)

        DrawRect(0.12, 0.165, 0.185, 0.206, 0, 0, 0, 150)
        DrawAdvancedText(0.127, 0.0999999999999996, 0.005, 0.0028, 0.4, "P&Q", 255, 255, 255, 255, 0, 1)
        DrawAdvancedText(0.128, 0.135, 0.005, 0.0028, 0.4, "Meteorite", 255, 255, 255, 255, 0, 1)
        DrawAdvancedText(0.293, 0.101, 0.005, 0.0028, 0.4, "$ 20", 255, 255, 255, 255, 0, 0)
        DrawAdvancedText(0.292, 0.134, 0.005, 0.0028, 0.4, "$ 30", 255, 255, 255, 255, 0, 0)
      end
    end
   end)
  end
end)
