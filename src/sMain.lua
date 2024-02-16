ESX = Config.CoreExport()

local cache = {
    counter = {},
}

AddEventHandler('onResourceStart', function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for k,v in pairs(ESX.GetExtendedPlayers()) do
        local jobName = v.job.name
        cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
    end

end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local jobName = xPlayer.job.name
    cache.counter[jobName] = (cache.counter[jobName] or 0) + 1
end)

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