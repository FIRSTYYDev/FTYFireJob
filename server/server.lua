ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent ('esx_society:registerSociety', 'pompier', 'pompier', 'society_pompier', {type = 'private'})



-- Coffre employé  



ESX.RegisterServerCallback('firejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pompier', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('firejob:getStockItem')
AddEventHandler('firejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pompier', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('firejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('firejob:putStockItems')
AddEventHandler('firejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pompier', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)





-- Revive !!!!!!

RegisterServerEvent('FTYPompier:setDeathStatus')
AddEventHandler('FTYPompier:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)

RegisterServerEvent('FTYPompier:revive')
AddEventHandler('FTYPompier:revive', function(target)
	playerId = tonumber(target)
    local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	local xPlayers = ESX.GetPlayers()
	if xTarget then
		if xPlayer.job.name == 'pompier' then
			TriggerClientEvent("FTYPompier:revive", xTarget.source)
			local societyAccount = nil
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pompier', function(account)
				societyAccount = account
			end)
			if societyAccount ~= nil then
				xPlayer.addMoney(150)
				societyAccount.addMoney(150)
				print('150$ ajouté')
			end
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'pompier' then
					TriggerClientEvent('FTYPompier:notif', xPlayers[i])
				end
			end
		end
	end
end)


















-- Mettre / Sortir Véhicule 


RegisterServerEvent('FTYPompier:putInVehicle')
AddEventHandler('FTYPompier:putInVehicle', function(target)
  TriggerClientEvent('FTYPompier:putInVehicle', target)
end)

RegisterServerEvent('FTYPompier:OutVehicle')
AddEventHandler('FTYPompier:OutVehicle', function(target)
    TriggerClientEvent('FTYPompier:OutVehicle', target)
end)

-- Annonce !!






RegisterServerEvent('annonceFireJobOuvert')
AddEventHandler('annonceFireJobOuvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Pompier', '~r~Annonce', 'LSFD est en service !', 'CHAR_CALL911', 8)
	end
end)

RegisterServerEvent('annonceFireJobFermer')
AddEventHandler('annonceFireJobFermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Pompier', '~r~Annonce', 'LSFD est plus en service !', 'CHAR_CALL911', 8)
	end
end)
