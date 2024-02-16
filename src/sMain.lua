ESX = Config.CoreExport()

local cache = {
    counter = {},
    processedPlayers = {}
}

AddEventHandler('onResourceStart', function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for k,v in pairs(ESX.GetExtendedPlayers()) do
        local playerId = v.source
        if not cache.processedPlayers[playerId] then
            cache.processedPlayers[playerId] = true
            local jobName = v.job.name
            cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
            cache.counter['players'] = (cache.counter['players'] or 0) + 1
            CheckAdmin(v.getGroup())
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local playerId = source
    if not cache.processedPlayers[playerId] then
        cache.processedPlayers[playerId] = true
        local jobName = xPlayer.job.name
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

    TriggerClientEvent('endorfy_scoreobard:reciveInfos', src, cache, myInfo)
end)