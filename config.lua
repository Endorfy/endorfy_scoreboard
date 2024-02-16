Config = {}

Config = {

    ServerName = "sadasd Development",

    CoreExport = function()
        return exports['es_extended']:getSharedObject() -- ESX
    end,

    Delay = { -- U set a delay to use a scoreboard to 5 seconds.
        Enabled = true,
        Time = 5000,
    },

    Notify = function (message)
        print(message)
    end,

    Locales = {
        waitsometime = "Please wait some time before next use!"
    },

    AdminGroups = {
        ["user"] = true
    }
}