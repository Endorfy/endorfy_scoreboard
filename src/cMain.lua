ESX = Config.CoreExport()

cache = {}
myInfo = {}
players = {}
local library = {
    globals = {},
    scoreboardLastTime = 6000,
    scoreboardUses = 5
}

library.mainThread = function(status)
    library.globals.scoreboardStatus = status
    SendNUIMessage({action = 'show', state = library.globals.scoreboardStatus})
    if library.globals.inUse then return end
    library.globals.inUse = true
    
    if library.scoreboardUses >= 3 then
        TriggerServerEvent('endorfy_scoreobard:getInfos')
        SendNUIMessage({action = 'update', cache = cache, myInfo = myInfo, ServerName = Config.ServerName})
        library.scoreboardUses = 0
    end

    if Config.Delay.Enabled and (GetGameTimer() - library.scoreboardLastTime < Config.Delay.Time) then
        return Config.Notify(Config.Locales.waitsometime)
    end

    library.scoreboardLastTime = GetGameTimer()
    library.scoreboardUses = library.scoreboardUses + 1

    if status then 
        library.drawThread()
    end
end

library.drawThread = function ()
    Citizen.CreateThread(function()
        while library.globals.scoreboardStatus do 
            local myPed = GetPlayerPed(-1)
            local myPedCoords = GetEntityCoords(myPed)

            for _, player in ipairs(GetActivePlayers()) do
                local playerPed = GetPlayerPed(player)
                local playerServerId = GetPlayerServerId(player)
                local playerPedCoords = GetEntityCoords(playerPed)
    
                if not Config.ShowMe and (myPed == playerPed) then 
                    return
                end

                if #(myPedCoords - playerPedCoords) < 50 then
                    DrawText3D(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z + 1.15, playerServerId, {255, 255, 255})
                end
            
                
                if players[tostring(playerServerId)] and Config.AdminGroups[players[tostring(playerServerId)].playerGroup] and Config.ShowGroups then
                    DrawText3D2(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z + 1.30, Config.AdminGroups[players[tostring(playerServerId)].playerGroup].Prefix, Config.AdminGroups[players[tostring(playerServerId)].playerGroup].Color)
                end                              
    
            end
    
            Citizen.Wait(1)
        end
    end)
end

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3D2(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.3 * scale, 0.65 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('endorfy_scoreobard:reciveInfos', function(playerss, cachee, myInfoo)
    cache = cachee 
    myInfo = myInfoo
    players = playerss
end)

RegisterCommand('+scoreboard', function()
    library.mainThread(true)
end, false)

RegisterCommand('-scoreboard', function()
    library.mainThread(false)
    library.globals.inUse = false
end, false)

RegisterKeyMapping('+scoreboard', 'Lista graczy', 'keyboard', 'Z')