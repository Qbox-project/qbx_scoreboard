local scoreboardOpen = false
local playerOptin = {}

local function shouldShowPlayerId(isTargetAdmin)
    local isClientAdmin = playerOptin[cache.serverId].isOnDutyAdmin
    if Config.IdVisibility == IdVisibility.ALL then return true end
    if isClientAdmin then return true end
    if Config.IdVisibility == IdVisibility.ADMIN_ONLY then return false end
    if Config.IdVisibility == IdVisibility.ADMIN_EXCLUDED and isTargetAdmin then return false end
    return true
end

local function drawPlayerNumbers()
    CreateThread(function()
        while scoreboardOpen do
            local players = cache('nearbyPlayers', function()
                return lib.getNearbyPlayers(GetEntityCoords(cache.ped), 10, true)
            end, 1000)
            for i = 1, #players do
                local player = players[i]
                local serverId = GetPlayerServerId(player.id)
                if shouldShowPlayerId(playerOptin[serverId].isOnDutyAdmin) then
                    DrawText3D('['..serverId..']', vec3(player.coords.x, player.coords.y, player.coords.z + 1.0))
                end
            end
            Wait(0)
        end
    end)
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Config.IllegalActions = lib.callback.await('qbx_scoreboard:server:getConfig')
end)

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

-- Command

local function openScoreboard()
    lib.callback('qbx_scoreboard:server:getScoreboardData', false, function(players, cops, playerList)
        playerOptin = playerList

        SendNUIMessage({
            action = 'open',
            players = players,
            maxPlayers = Config.MaxPlayers,
            requiredCops = Config.IllegalActions,
            currentCops = cops
        })

        scoreboardOpen = true
        drawPlayerNumbers()
    end)
end

local function closeScoreboard()
    SendNUIMessage({
        action = 'close',
    })

    scoreboardOpen = false
end

if Config.Toggle then
    lib.addKeybind({
        name = 'scoreboard',
        description = 'Open Scoreboard',
        defaultKey = Config.OpenKey,
        onPressed = function(self)
            scoreboardOpen = not scoreboardOpen
            if scoreboardOpen then openScoreboard() end
            closeScoreboard()
        end,
    })
else
    lib.addKeybind({
        name = 'scoreboard',
        description = 'Open Scoreboard',
        defaultKey = Config.OpenKey,
        onPressed = openScoreboard,
        onReleased = closeScoreboard
    })
end

-- Threads

CreateThread(function()
    Wait(1000)
    local actions = {}
    for k, v in pairs(Config.IllegalActions) do
        actions[k] = v.label
    end
    SendNUIMessage({
        action = 'setup',
        items = actions
    })
end)
