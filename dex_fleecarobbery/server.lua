ESX = exports["es_extended"]:getSharedObject()

Doors = {
    ["F0"] = {{loc = vector3(-105.15334320068,6472.7075195312,31.626728057861), h = 42.639282226562, txtloc = vector3(-105.34651184082,6472.708984375,31.626726150513), obj = nil, locked = false}, {loc = vector3(-105.84294891357,6475.4428710938,31.62670135498), txtloc = vector3(-105.84294891357,6475.4428710938,31.62670135498), obj = nil, locked = false}},
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = true}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = true}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = true}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = true}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = true}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = true}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("DEX_fh:startcheck")
AddEventHandler("DEX_fh:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = xPlayer.getInventoryItem("id_card_f")["count"]

    if copcount >= DEX.mincops then
        if item >= 1 then
            if not DEX.Banks[bank].onaction == true then
                if (os.time() - DEX.cooldown) > DEX.Banks[bank].lastrobbed then
                    DEX.Banks[bank].onaction = true
                    xPlayer.removeInventoryItem("id_card_f", 1)
                    TriggerClientEvent("DEX_fh:outcome", _source, true, bank)
                    TriggerClientEvent("DEX_fh:policenotify", -1, bank)
                else
                    TriggerClientEvent("DEX_fh:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((DEX.cooldown - (os.time() - DEX.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((DEX.cooldown - (os.time() - DEX.Banks[bank].lastrobbed)), 60))
                end
            else
                TriggerClientEvent("DEX_fh:outcome", _source, false, "This bank is currently being robbed.")
            end
        else
            TriggerClientEvent("DEX_fh:outcome", _source, false, "You don't have a malicious access card.")
        end
    else
        TriggerClientEvent("DEX_fh:outcome", _source, false, "There is not enough police in the city.")
    end
end)

RegisterServerEvent("DEX_fh:lootup")
AddEventHandler("DEX_fh:lootup", function(var, var2)
    TriggerClientEvent("DEX_fh:lootup_c", -1, var, var2)
end)

RegisterServerEvent("DEX_fh:openDoor")
AddEventHandler("DEX_fh:openDoor", function(coords, method)
    TriggerClientEvent("DEX_fh:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("DEX_fh:toggleDoor")
AddEventHandler("DEX_fh:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("DEX_fh:toggleDoor", -1, key, state)
end)

RegisterServerEvent("DEX_fh:toggleVault")
AddEventHandler("DEX_fh:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("DEX_fh:toggleVault", -1, key, state)
end)

RegisterServerEvent("DEX_fh:updateVaultState")
AddEventHandler("DEX_fh:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("DEX_fh:startLoot")
AddEventHandler("DEX_fh:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("DEX_fh:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("DEX_fh:startLoot_c", _source, data, name)
end)

RegisterServerEvent("DEX_fh:stopHeist")
AddEventHandler("DEX_fh:stopHeist", function(name)
    TriggerClientEvent("DEX_fh:stopHeist_c", -1, name)
end)

RegisterServerEvent("DEX_fh:rewardCash")
AddEventHandler("DEX_fh:rewardCash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = math.random(DEX.mincash, DEX.maxcash)

    if DEX.black then
        xPlayer.addAccountMoney("black_money", reward)
    else
        xPlayer.addMoney(reward)
    end
end)

RegisterServerEvent("DEX_fh:setCooldown")
AddEventHandler("DEX_fh:setCooldown", function(name)
    DEX.Banks[name].lastrobbed = os.time()
    DEX.Banks[name].onaction = false
    TriggerClientEvent("DEX_fh:resetDoorState", -1, name)
end)

ESX.RegisterServerCallback("DEX_fh:getBanks", function(source, cb)
    cb(DEX.Banks, Doors)
end)