ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local me = PlayerPedId()
        local pos = GetEntityCoords(me, false)
        for i=1, #Config.Zones, 1 do
            local dist = Vdist(pos.x, pos.y, pos.z, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z)
            DrawMarker(27, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0, 0, 0, 0, 0, 0, Config.Marker.size.x,Config.Marker.size.y, Config.Marker.size.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a, 0, 0, 0, 0)
            if dist <= Config.Distance then
                ESX.ShowHelpNotification(Config.Zones[i].text)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("esx_bitcoin:newAccount")
                    Citizen.Wait(500)
                    ESX.TriggerServerCallback("esx_bitcoin:getStatus", function(data)
                    EnableNUI(true, data.id, tonumber(string.format("%.7f", data.bitcoin)))
                    end)
                end
            end
        end
    end
end)

RegisterNUICallback("close", function()
    EnableNUI(false)
end)

RegisterNUICallback("esx_bitcoin:jsAction", function(data)
    TriggerServerEvent("esx_bitcoin:action", data.type, data.value)
end)

function EnableNUI(bool, id, bitcoin)
    SetNuiFocus(bool, bool)
    SendNUIMessage({ enable = bool, id = id, bitcoin = bitcoin })
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end
