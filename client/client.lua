ESX = nil

Keys.Register("F6", "F6", "Pompier", function()
  menu()
end)

function menu()

  local menuFirejob = RageUI.CreateMenu("Pompier","~r~Menu Pompier ")
  local menuInteracFire = 1
  local menuAnnonceFire = 1
  local xPlayer = ESX.GetPlayerData
  local montant = 0
  local raison = ""
  menuFirejob:SetRectangleBanner(215, 40, 40)

  RageUI.Visible(menuFirejob, not RageUI.Visible(menuFirejob))


  while menuFirejob do
      
      Citizen.Wait(0)

      RageUI.IsVisible(menuFirejob,function()

              RageUI.Line()

              RageUI.Separator("~y~ Badge Pompier →"..GetPlayerName(PlayerId()))
            



              RageUI.Line()
              
            
              RageUI.List("Citoyen  ~r~→", {"Réanimer","Soigner","Mettre dans un véhicule"}, menuInteracFire,"~y~Interactions Citoyens",{},true,{
                onListChange= function(Index)
                    menuInteracFire = Index
                end,
                onSelected = function(Index)
                  local closestPlayer,closestDistance = ESX.Game.GetClosestPlayer()
                  if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    if Index == 1 then
                      TriggerServerEvent('FTYPompier:revive', GetPlayerServerId(closestPlayer))
                      print("^1 Réanimations Réussi")
                    end
                    if Index == 2 then 
                      TriggerServerEvent('firejob:heal', GetPlayerServerId(closestPlayer))
                      print("^1 Heal Réussi")
                    end
                    if Index == 3 then
                      TriggerServerEvent('FTYPompier:putInVehicle', GetPlayerServerId(closestPlayer))
                      print("^1 Mettre dans le vehicule Réussi")
                    end
                  else
                    ESX.ShowNotification('Personne autour')
                  end
              end
            
                        })

                RageUI.List("Annonces  ~r~→", {"En service","Hors service"}, menuAnnonceFire,"~y~Menu des annonces",{},true,{
                    onListChange= function(Index)
                        menuAnnonceFire = Index
                    end,
                    onSelected = function(Index)
                      if Index == 1 then
                          TriggerServerEvent('annonceFireJobOuvert')
                          print("^1 Annonce Open Réussi")
                    end
                    if Index == 2 then
                          TriggerServerEvent('annonceFireJobFermer')
                         print("^1 Annonce Close Réussi")
                    end
                  end
   
                    })


                    RageUI.Button("Facture ~r~→", "~y~Faire une facture", {}, true, {
                      onSelected = function()
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        local player,distance = ESX.Game.GetClosestPlayer()
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_pompier', ('pompier'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                  end
                                end
                              end
                            end      
                                   })

           
      

      end, function()
      end)
  end

  if not RageUI.Visible(menuFirejob) then
    menuFirejob=RMenu:DeleteType("menuFirejob",true)
  end
end


-- Blips FireJob V1 

local blips = {

    {title="~y~Los Santos Fire Department", colour=1, id=648, x = 1185.3974609375, y = -1475.9377441406, z = 34.692260742188}
 }
     
Citizen.CreateThread(function()

   for _, info in pairs(blips) do
     info.blip = AddBlipForCoord(info.x, info.y, info.z)
     SetBlipSprite(info.blip, info.id)
     SetBlipDisplay(info.blip, 4)
     SetBlipScale(info.blip, 0.8)
     SetBlipColour(info.blip, info.colour)
     SetBlipAsShortRange(info.blip, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(info.title)
     EndTextCommandSetBlipName(info.blip)
   end
end)





-- Annonces

RegisterNetEvent('FTYPompier:putInVehicle')
AddEventHandler('FTYPompier:putInVehicle', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
    if DoesEntityExist(vehicle) then
      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil
      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end
      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end
    end
  end
end)

RegisterNetEvent('FTYPompier:OutVehicle')
AddEventHandler('FTYPompier:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)



--Revive


RegisterNetEvent('FTYPompier:revive')
AddEventHandler('FTYPompier:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    TriggerServerEvent('FTYPompier:setDeathStatus', false)
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Citizen.Wait(50)
    end

    local formattedCoords = {
        x = ESX.Math.Round(coords.x, 1),
        y = ESX.Math.Round(coords.y, 1),
        z = ESX.Math.Round(coords.z, 1)
    }

    ESX.SetPlayerData('lastPosition', formattedCoords)

    TriggerServerEvent('esx:updateLastPosition', formattedCoords)

    RespawnPed(playerPed, formattedCoords, 0.0)

    StopScreenEffect('DeathFailOut')
    DoScreenFadeIn(800)
end)

--RespawnPed

function RespawnPed(ped,coords,heading)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
  TriggerEvent("esx:onPlayerSpawn")
  ESX.UI.Menu.CloseAll()
end
