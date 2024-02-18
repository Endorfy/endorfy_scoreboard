Config = {}

Config = {

    ServerName = "Endorfy Development", -- Ur server name
    ShowMe = true, -- U will see ur id when pressed button of scoreboard
    ShowInvisibleIds = false, -- U will see ids of peoples who are invisible
    ShowIsUsingScoreboard = true, -- Will show on player ! if using scoreboard

    ShowGroups = true, -- ShowGroups means that u will see a group of player under his head
    AdminGroups = { -- Put here ur admin ranks
        ["owner"] = {Admin = true, Prefix = "Owner", Color = {135, 234, 231}},
        ["superadmin"] = {Admin = true, Prefix = "Super Admin", Color = {242, 234, 0}},
        ["admin"] = {Admin = true, Prefix = "Administrator", Color = {242, 234, 0}}
    },

    Delay = { -- U set a delay to use a scoreboard to 5 seconds.
        Enabled = false,
        Time = 5000,
    },

    Locales = {
        waitsometime = "Please wait some time before next use!" -- It is usable when u have enabled delay option 
    },

    -- Functions

    Notify = function (message) -- U can here use ur notify or smth
        print(message)
        -- like exports['endorfy_notify']:showNotify('type', 'message', 'time')
    end,

    CoreExport = function()
        return exports['es_extended']:getSharedObject() -- ESX
    end
}