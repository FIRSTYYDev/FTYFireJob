local MaxFireLimit = Config.MaxFlames
local Fires = {}
local FinalCoords = nil

function StartFireSync(FiresReturn)
    Fires = FiresReturn
    FinalCoords = FiresReturn[1].coords
    TriggerClientEvent('FireScript:StartFireClient', -1, Fires)
end

RegisterServerEvent('FireScript:StopFire')
AddEventHandler('FireScript:StopFire', function(returncoords)
    local coords
    if returncoords then
        coords = returncoords
    else
        coords = FinalCoords
    end

    TriggerClientEvent('FireScript:StopFireSync', -1, coords)
    Fires = {}
    Wait(10*1000)
end)


RegisterServerEvent('FireScript:PlayerJoined')
AddEventHandler('FireScript:PlayerJoined', function()
    local _source = source
    if Config.AdminCommand then
        TriggerClientEvent('chat:addSuggestion', _source, '/startfire', 'Paradox Fire Dispatch: Start fire', {
            { name='Number of flames', help='Number of flames to spawn (intensity)' },
            { name='Radius of fire', help='Width of the fire (randomly will spawn fires in this width)' }
        })
    end
    if #Fires > 0 then
        TriggerClientEvent('FireScript:StartFireClient', _source, Fires)
    end
end)

local cooldown = false

function cooldownFire()
    Citizen.CreateThread(function()
        cooldown = true
        Wait(3000)
        cooldown = false
    end)
end
RegisterServerEvent('FireScript:SyncFlamesSv')
AddEventHandler('FireScript:SyncFlamesSv', function(coords)
    CreateThread(function()
        ---- Secondary checks based on fires on serverside -----
        for k,v in pairs(Fires) do
            if v.coords == coords then
                v = nil
            end
        end
        if #Fires < 3 then
            if not cooldown then
                cooldownFire()
                TriggerEvent('FireScript:StopFire', coords)
            end
        end
        TriggerClientEvent('FireScript:SyncFlames', -1, coords)
    end)
end)


RegisterServerEvent("FireScript:StartFire")
AddEventHandler("FireScript:StartFire", function(sender, position, flames, radius)
    TriggerClientEvent('FireScript:GetCoords', sender, position, flames, radius)
end)
