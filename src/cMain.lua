ESX = Config.CoreExport()

local cache = {}
local myInfo = {}
local library = {
    globals = {},
    scoreboardLastTime = 6000
}

library.mainThread = function(status)
    library.globals.scoreboardStatus = status
    if library.globals.inUse then return end
    library.globals.inUse = true
    TriggerServerEvent('endorfy_scoreobard:getInfos')

    if Config.Delay.Enabled and (GetGameTimer() - library.scoreboardLastTime < Config.Delay.Time) then
        return Config.Notify(Config.Locales.waitsometime)
    end

    library.scoreboardLastTime = GetGameTimer()

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
    
                if #(myPedCoords - playerPedCoords) < 50 then
                    DrawText3D(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z + 1.15, playerServerId, {255, 255, 255})
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

RegisterNetEvent('endorfy_scoreobard:reciveInfos', function(cache, myInfo)
    cache = cache myInfo = myInfo
end)

RegisterCommand('+scoreboard', function()
    library.mainThread(true)
end, false)

RegisterCommand('-scoreboard', function()
    library.mainThread(false)
    library.globals.inUse = false
end, false)

RegisterKeyMapping('+scoreboard', 'Lista graczy', 'keyboard', 'Z')