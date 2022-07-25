function Coffrepompier()
    local Cpompier = RageUI.CreateMenu("Coffre", "pompier")
        RageUI.Visible(Cpompier, not RageUI.Visible(Cpompier))
            while Cpompier do
            Citizen.Wait(0)
            RageUI.IsVisible(Cpompier, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Vêtements ↓")

                    RageUI.ButtonWithStyle("Tenue de travail",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenuepompier()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Remettre sa tenue",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vcivil()
                            RageUI.CloseAll()
                        end
                    end)

                end, function()
                end)
            if not RageUI.Visible(Cpompier) then
            Cpompier = RMenu:DeleteType("Cpompier", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pompier' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, pompier.position.coffre.position.x, pompier.position.coffre.position.y, pompier.position.coffre.position.z)
            if jobdist <= 10.0 and pompier.marker then
                Timer = 0
                DrawMarker(20, pompier.position.coffre.position.x, pompier.position.coffre.position.y, pompier.position.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 215, 40, 40, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrepompier()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)











itemstock = {}
function TRetirerobjet()
    local Stockpompier = RageUI.CreateMenu("Coffre", "pompier")
    ESX.TriggerServerCallback('cpompier:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockpompier, not RageUI.Visible(Stockpompier))
        while Stockpompier do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockpompier, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('cpompier:getStockItem', v.name, tonumber(count))
                                    TRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockpompier) then
            Stockpompier = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function TDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "pompier")
    ESX.TriggerServerCallback('cpompier:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('cpompier:putStockItems', item.name, tonumber(count))
                                            TDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end








