ESX = Config.CoreExport()

local cache = {
    counter = {},
    players = {},
    processedPlayers = {}
}

AddEventHandler('esx:setGroup', function(source, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.source
    cache.players[tostring(playerId)] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
end)

AddStateBagChangeHandler("group", nil, function(bagName, key, value) 
    local src = tonumber(string.match(bagName, "%d+"))

    if src then
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerId = xPlayer.source
        cache.players[tostring(playerId)] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for k,v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local playerId = xPlayer.source
        if not cache.processedPlayers[playerId] then
            cache.processedPlayers[playerId] = true
            local jobName = xPlayer.job.name
            cache.players[tostring(playerId)] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
            cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
            cache.counter['players'] = (cache.counter['players'] or 0) + 1
            CheckAdmin(xPlayer.getGroup())
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local playerId = source
    if not cache.processedPlayers[playerId] then
        cache.processedPlayers[playerId] = true
        local jobName = xPlayer.job.name
        cache.players[playerId] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
        cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
        cache.counter['players'] = (cache.counter['players'] or 0) + 1
        CheckAdmin(xPlayer.getGroup())
    end
end)

CheckAdmin = function(group)
    if Config.AdminGroups[group] then
        cache.counter['admins'] = (cache.counter['admins'] or 0) + 1
    end
end

RegisterNetEvent('endorfy_scoreobard:getInfos', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local myInfo = {
        Name = xPlayer.getName(),
        Job = xPlayer.job.name,
        Group = xPlayer.getGroup(),
    }

    TriggerClientEvent('endorfy_scoreobard:reciveInfos', src, cache.players, cache.counter, myInfo)
end)