Config = Config or {}

-- Open scoreboard key
Config.OpenKey = 'HOME' -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

Config.Toggle = true -- If this is false the scoreboard stays open only when you hold the OpenKey button, if this is true the scoreboard will be openned and closed with the OpenKey button

-- Max Server Players
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- It returns 48 if it cant find the Convar Int

-- Minimum Police for Actions
Config.IllegalActions = {
    storerobbery = {
        minimumPolice = 2,
        busy = false,
        label = 'Store Robbery',
    },
    bankrobbery = {
        minimumPolice = 3,
        busy = false,
        label = 'Bank Robbery'
    },
    jewellery = {
        minimumPolice = 2,
        busy = false,
        label = 'Jewelry'
    },
    pacific = {
        minimumPolice = 5,
        busy = false,
        label = 'Pacific Bank'
    },
    paleto = {
        minimumPolice = 4,
        busy = false,
        label = 'Paleto Bay Bank'
    }
}

---@enum IdVisibility
IdVisibility = {
    ADMIN_ONLY = 1, -- only admins can see player ids
    ADMIN_EXCLUDED = 2, -- all players will see player ids except for those of admins
    ALL = 3 -- all ids are viewable for all players and of all players
}

Config.IdVisibility = IdVisibility.ADMIN_ONLY


