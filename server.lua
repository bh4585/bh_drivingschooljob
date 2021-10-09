ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_society:registerSociety', 'driving', 'driving', 'society_driving', 'society_driving', 'society_driving', {type = 'private'})



ESX.RegisterServerCallback('drivingschool:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent('drivingschool:putStockItems')
AddEventHandler('drivingschool:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'you deposit ', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Invalid amount')
		end
	end)
end)

ESX.RegisterServerCallback('drivingschool:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('bh_drivingschool:getStockItem')
AddEventHandler('bh_drivingschool:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification('you take from stock', count, inventoryItem.name)
			else
				xPlayer.showNotification('Invalid amount')
			end
		else
			xPlayer.showNotification('Invalid amount')
		end
	end)
end)    