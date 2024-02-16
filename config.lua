Config = {}

Config = {
    ServerName = "Endorfy Development", -- Ur server name

    CoreExport = function()
        return exports['es_extended']:getSharedObject() -- ESX
    end,

    Delay = { -- U set a delay to use a scoreboard to 5 seconds.
        Enabled = true,
        Time = 5000,
    },

    Notify = function (message) -- U can here use ur notify or smth
        print(message)
    end,

    Locales = {
        waitsometime = "Please wait some time before next use!"
    },

    AdminGroups = { -- Put here ur admin ranks
        ["owner"] = true,
        ["superadmin"] = true,
        ["moderator"] = true,
        ["support"] = true,
        ["trialsupport"] = true
    }
}