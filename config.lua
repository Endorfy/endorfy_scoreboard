Config = {}

Config = {
    ServerName = "Endorfy Development", -- Ur server name

    CoreExport = function()
        return exports['es_extended']:getSharedObject() -- ESX
    end,

    Delay = { -- U set a delay to use a scoreboard to 5 seconds.
        Enabled = false,
        Time = 5000,
    },

    Notify = function (message) -- U can here use ur notify or smth
        print(message)
        -- like exports['endorfy_notify']:showNotify('type', 'message', 'time')
    end,

    Locales = {
        waitsometime = "Please wait some time before next use!"
    },

    ShowGroups = true, -- ShowGroups means that u will see a group of player under his head
    AdminGroups = { -- Put here ur admin ranks
        ["owner"] = {Enabled = true, Prefix = "Owner", Color = {0,0,0}},
        ["superadmin"] = {Enabled = true, Prefix = "Super Admin", Color = {242, 234, 0}}
    }
}