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

RegisterNetEvent('esx:setJob', function(src, job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(src)
    local newJobName = job.name
    local lastJobName = lastJob.name

    if job.name ~= lastJob.name then
        cache.counter[newJobName] = (cache.counter[newJobName] or 0) + 1
        cache.counter[lastJobName] = (cache.counter[lastJobName] or 1) - 1
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for k,v in pairs(GetPlayers()) do
        if not v then return end
        local xPlayer = ESX.GetPlayerFromId(v)
        local playerId = xPlayer.source
        if not cache.processedPlayers[playerId] then
            cache.processedPlayers[playerId] = true
            local jobName = xPlayer.job.name
            cache.players[tostring(playerId)] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
            cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
            cache.counter['players'] = (cache.counter['players'] or 0) + 1
            CheckAdmin(xPlayer.getGroup(), "join")
        end
    end
end)

AddEventHandler('esx:playerDropped', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.source
    local jobName = xPlayer.job.name
    cache.counter[jobName] = (cache.counter[jobName] or 1) - 1
    cache.players[tostring(playerId)] = nil
    cache.counter['players'] = (cache.counter['players'] or 0) - 1
    CheckAdmin(xPlayer.getGroup(), "left") 
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local playerId = xPlayer.source
    if not cache.processedPlayers[playerId] then
        cache.processedPlayers[playerId] = true
        local jobName = xPlayer.job.name
        cache.players[tostring(playerId)] = {playerId = playerId, playerGroup = xPlayer.getGroup()}
        cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
        cache.counter['players'] = (cache.counter['players'] or 0) + 1
        CheckAdmin(xPlayer.getGroup(), "join")
    end
end)

CheckAdmin = function(group, status)
    if Config.AdminGroups[group].Admin then
        if status == "join" then
            cache.counter['admins'] = (cache.counter['admins'] or 0) + 1
        elseif status == "left" then 
            cache.counter['admins'] = (cache.counter['admins'] or 0) - 1
        end
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

    local cachedPlayer = cache.players[tostring(xPlayer.source)]

    if not cachedPlayer or cachedPlayer.playerGroup ~= myInfo.Group then
        cache.players[tostring(xPlayer.source)] = {playerId = xPlayer.source, playerGroup = xPlayer.getGroup()}
    end

    TriggerClientEvent('endorfy_scoreobard:reciveInfos', src, cache.players, cache.counter, myInfo)
end)

-- RegisterCommand("debug", function(source)
--     if source == 0 then
--         print(json.encode(cache.counter))
--         print(json.encode(cache.players))
--     end
-- end)