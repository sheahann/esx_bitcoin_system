ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_bitcoin:action")
AddEventHandler("esx_bitcoin:action", function(type, value)
    local identifier = GetPlayerIdentifiers(source)[1]
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()
    local data = MySQL.Sync.fetchAll("SELECT * FROM bitcoin_accounts WHERE identifier = @identifier", {["@identifier"] = identifier})
    local dataMoney = data[1].bitcoins
    local bitcoinData = MySQL.Sync.fetchAll("SELECT * FROM esx_bitcoin_status",{})
    local bitcoin = bitcoinData[1].Price

    if type == "buy" then
        if xMoney >= value * bitcoin then
            local finalMoney = dataMoney + value
            xPlayer.removeMoney(value * bitcoin)
            MySQL.Async.execute('UPDATE bitcoin_accounts SET bitcoins = @finalMoney WHERE identifier = @identifier', {['@identifier'] = identifier, ['@finalMoney'] = finalMoney})
            TriggerClientEvent("chatMessage", source, "^3Bitcoin^0 ", {255, 255, 255}, "You successfully bought " .. value .. " bitcoins")
            MySQL.Async.execute('UPDATE esx_bitcoin_status SET Price = @bitcoinPrice', {["bitcoinPrice"] = bitcoin + Config.BitcoinChanger + 100 * value})
            TriggerClientEvent("esx:showNotification", source, "~r~-" .. value * bitcoin .. "~w~")
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Error~w~: You don't have enough money")
        end
    end
    if type == "sell" then
        if tonumber(dataMoney) >= tonumber(value) then
            local finalMoney = dataMoney - value
            MySQL.Async.execute('UPDATE bitcoin_accounts SET bitcoins = @finalMoney WHERE identifier = @identifier', {['@identifier'] = identifier, ['@finalMoney'] = finalMoney})
            xPlayer.addMoney(value * bitcoin)
            TriggerClientEvent("chatMessage", source, "^3Bitcoin^0 ", {255, 255, 255}, "You successfully sold " .. value .. " bitcoins")
            MySQL.Async.execute('UPDATE esx_bitcoin_status SET Price = @bitcoinPrice', {["bitcoinPrice"] = bitcoin - Config.BitcoinChanger * value})
            TriggerClientEvent("esx:showNotification", source, "~g~+" .. value * bitcoin .. "~w~")
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Error~w~: You don't have enough bitcoins")
        end
    end
end)

ESX.RegisterServerCallback("esx_bitcoin:getStatus", function(source, cb)
    local identifier = GetPlayerIdentifiers(source)[1]
    local get = MySQL.Sync.fetchAll("SELECT * FROM bitcoin_accounts WHERE identifier = @identifier", {['@identifier'] = identifier})
    local data = get[1]

    local id = data.account_id
    local bitcoin = data.bitcoins
    cb({ id = id, bitcoin = bitcoin })
end)

RegisterServerEvent("esx_bitcoin:newAccount")
AddEventHandler("esx_bitcoin:newAccount", function()
    local identifier = GetPlayerIdentifiers(source)[1]
    local user = MySQL.Sync.fetchAll("SELECT * FROM bitcoin_accounts WHERE identifier = @identifier", {['@identifier'] = identifier})
        if user[1] == nil then
            MySQL.Async.execute('INSERT INTO bitcoin_accounts (identifier, ooc_name, account_id, bitcoins) VALUES (@identifier, @ooc_name, @account_id, @bitcoins)', {['@identifier'] = identifier, ['@ooc_name'] = GetPlayerName(source), ['account_id'] = GetNewId(), ['bitcoins'] = 0})
        else
            print("^2" .. user[1].ooc_name .. " is already registered in bitcoin system^0")
    end
end)

function GetRandomVariable()
    local num1 = math.random(100,999)
    local num2 = math.random(0,9999)
    local num = string.format(num1, num2)
	return num
end

function GetNewId()
    local res = ""
	for i = 1, 5 do
		res = res .. string.char(math.random(97, 122))
    end
    local get = MySQL.Sync.fetchAll("SELECT * FROM bitcoin_accounts", {})
    if get[1] ~= nil then 
        repeat
            res = res .. string.char(math.random(97, 122))
        until get[1] == nil
    end
    return "#" .. res .. GetRandomVariable()
end