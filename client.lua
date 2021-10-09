ESX = nil

local NPC = {
    {model = "ig_abigail", x = -926.6,  y = -171.0,  z = 36.32, h = 220.0},
}


local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    for _, v in pairs(NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end
        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

    local peds = {
        `ig_abigail`,
    }
---------------------------------------------------
exports['qtarget']:AddTargetModel(peds, {
        options = {
       	{
        event = "",
        icon = "fas fa-shopping-cart",
        label = "Take theory test",
        },        	
    },
        job = {"all"},
        distance = 2.5
    })
---------------------------------------------------
Citizen.CreateThread(function()
    while true do 
        local _msec = 250
        if PlayerData.job and PlayerData.job.name == 'driving' then
            _msec = 0
            if IsControlJustPressed(0, 167) then
                ESX.ShowNotification('🚘 | DrivingSchool')
                TriggerEvent('bh-contextmenu')
            end
        end
        Citizen.Wait(_msec)
    end
end)

Citizen.CreateThread(function()
    while true do
        local _msec = 250
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        for k,v in pairs(Config.MenuGeneral) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'driving' then
                    ESX.ShowFloatingHelpNotification('~b~[E]~w~ | DMV MENU', v)
                    if IsControlJustPressed(0,38) then
                        TriggerEvent('bh-general')
                    end
                end
            end
        end

        for k,v in pairs(Config.DeleteCar) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'driving' then
                    ESX.ShowFloatingHelpNotification('~b~[E]~w~ | DELETE VEHICLE', v)
                    if IsControlJustPressed(0,38) then
                        ESX.ShowNotification('Good, you back vehicle')
                        DeleteVehicle(vehicle)
                    end
                end
            end
        end
        Citizen.Wait(_msec)
    end
end)

RegisterNetEvent('bh-contextmenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "🚦 DrivingSchool Actions 🚦",
            txt = "",
        },
	    {
            id = 2,
            header = "📖 Theory Test 📖",
            txt = "give theory test",
            params = {
                event = "daj:dmv"
            }
        },
        {
            id = 3,
            header = "🏍 Bike License 🏍",
            txt = "give license for bike",
            params = {
                event = "daj:a"
            }
        },
        {
            id = 4,
            header = "🚗 Car License 🚗",
            txt = "give license for car",
            params = {
                event = "daj:b"
            }
        },
	    {
            id = 5,
            header = "🚚 Truck License 🚚",
            txt = "give license for truck",
            params = {
                event = "daj:c"
            }
        },
        {
            id = 6,
            header = "📝 Billing  📝",
            txt = "bill closest player for service",
            params = {
                event = "daj:racun"
            }
        },
    })
end)

RegisterNetEvent('bh-general', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "DrivingSchool General Menu",
            txt = "",
        },
        {
            id = 2,
            header = "Deposit item",
            txt = "deposit any item from your inventory",
            params = {
                event = "dmvjob:inventory",
                args = {
                    invOption = "a"
                }
            }
        },
        {
            id = 3,
            header = "Withdraw Item",
            txt = "take item from stock",
            params = {
                event = "dmvjob:inventory",
                args = {
                    invOption = "b"
                }
            }
        },
        {
            id = 4,
            header = "Vehicles Menu",
            txt = "take out vehicle",
            params = {
                event = "bh-cars"
            }
        },

        {
            id = 5,
            header = "Boss Actions",
            txt = "",
            params = {
                event = "dmvjob:society"
            }
        },
    })
end)

RegisterNetEvent('bh-cars', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = 'Vehicles',
            txt = ''
        },
        {
            id = 1,
            header = "Bike",
            txt = 'take out bike',
            params = {
                event = "dmvjob:cars",
                args = {
                    spawncar = 'soveregin'
                }
            }
        },
        {
            id = 2,
            header = "Car",
            txt = 'take out car',
            params = {
                event = "dmvjob:cars",
                args = {
                    spawncar = 'primo'
                }
            }
        },
        {
            id = 3,
            header = "Truck",
            txt = 'take out truck',
            params = {
                event = "dmvjob:cars",
                args = {
                    spawncar = 'mule4'
                }
            }
        },	
        {
            id = 4,
            header = "Boss Car",
            txt = 'take out car',
            params = {
                event = "dmvjob:cars",
                args = {
                    spawncar = 'tailgater2'
                }
            }
        },

    })
end)

RegisterNetEvent('dmvjob:cars')
AddEventHandler('dmvjob:cars', function(data)
    local spawncar = data.spawncar
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    for k,v in pairs(Config.Cars) do
        Citizen.Wait(0)
        if spawncar == 'tailgater2' and PlayerData.job.grade_name == 'boss' then
            DoScreenFadeOut(500)

            ESX.Game.SpawnVehicle(spawncar, v, 168.5, function(vehicle)
                ESX.ShowNotification('you take vehicle')
                Citizen.Wait(2000)
                DoScreenFadeIn(2000)

                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
            
        elseif spawncar ~= 'tailgater2' then
            DoScreenFadeOut(500)

            ESX.Game.SpawnVehicle(spawncar, v, 168.5, function(vehicle)
                ESX.ShowNotification('you take vehicle ')
                Citizen.Wait(2000)
                DoScreenFadeIn(2000)

                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)

        else
            ESX.ShowNotification('Only Boss can drive that car')
        end
    end
end)

RegisterNetEvent('dmvjob:inventory')
AddEventHandler('dmvjob:inventory', function(data)
    local invOption = data.invOption
    if invOption == 'a' then
        OpenPutStocksMenu()
    elseif invOption == 'b' then
        OpenGetStocksMenu()
    end
end)

RegisterNetEvent('dmvjob:society')
AddEventHandler('dmvjob:society', function()
    if PlayerData.job.grade_name == 'boss' then
        print(PlayerData.job.grade_name)
        ESX.ShowNotification('Society Menu')
        TriggerEvent('esx_society:openBossMenu', 'driving', function(data, menu)
            menu.close()
            align    = 'bottom-right'
        end, { wash = false })
    elseif PlayerData.job.grade_name ~= 'boss' then
        ESX.ShowNotification('You are not Boss')
    end
end)

RegisterNetEvent('daj:dmv')
AddEventHandler('daj:dmv', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'dmv')
	ESX.ShowNotification('You give dmv')
    else      
	    ESX.ShowNotification('No players nearby')	
    end
end)

RegisterNetEvent('daj:a')
AddEventHandler('daj:a', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'drive_bike')
	ESX.ShowNotification('You give license for bike')
    else      
	    ESX.ShowNotification('No players nearby')	
    end
end)	

RegisterNetEvent('daj:b')
AddEventHandler('daj:b', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'drive')
	ESX.ShowNotification('You give license for car')
    else      
	    ESX.ShowNotification('No players nearby')	
    end
end)

RegisterNetEvent('daj:c')
AddEventHandler('daj:c', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'drive_truck')
	ESX.ShowNotification('You give license for truck')
    else      
	    ESX.ShowNotification('No players nearby')
    end
end)	

RegisterNetEvent('daj:racun')
AddEventHandler('daj:racun', function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    local coords    = GetEntityCoords(playerPed)
--
ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
	title = 'DrivingSchool Billing Service'
}, function(data, menu)
	local amount = tonumber(data.value)

	if amount == nil or amount < 0 then
		ESX.ShowNotification('Invalid amount')
	else
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer == -1 or closestDistance > 3.0 then
			ESX.ShowNotification('No players nearby')
		else
			menu.close()
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_driving', 'Driving School', amount)
			ESX.ShowNotification('you give bill to nerby player')
		end
	end
end, function(data, menu)
		menu.close()
	end)
end)


OpenPutStocksMenu = function()
	ESX.TriggerServerCallback('drivingschool:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'your inventory',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'amount'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Invalid amount')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('drivingschool:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

OpenGetStocksMenu = function()
	ESX.TriggerServerCallback('drivingschool:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Stock',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'amount'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Invalid amount')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('drivingschool:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

Citizen.CreateThread(function()
	for k,v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, 77)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, 35)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Driving School')
		EndTextCommandSetBlipName(blip)
		print("bh_drivingschooljob: job is ready without errors..")
	end
end)