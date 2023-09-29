local scoreboardOpen = false
local playerOptin = {}

local function shouldShowPlayerId(isTargetAdmin)
    local isClientAdmin = playerOptin[cache.playerId].isOnDutyAdmin
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
                if shouldShowPlayerId(playerOptin[player.id].isOnDutyAdmin) then
                    DrawText3D(vec3(player.coords.x, player.coords.y, player.coords.z + 1.0), '['..player.id..']')
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
            action = "open",
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
        action = "close",
    })

    scoreboardOpen = false
end

if Config.Toggle then
    RegisterCommand('scoreboard', function()
        if scoreboardOpen then closeScoreboard() else openScoreboard() end
    end, false)

    RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
else
    RegisterCommand('+scoreboard', function()
        if scoreboardOpen then return end
        openScoreboard()
    end, false)

    RegisterCommand('-scoreboard', function()
        if not scoreboardOpen then return end
        closeScoreboard()
    end, false)

    RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
end

-- Threads

CreateThread(function()
    Wait(1000)
    local actions = {}
    for k, v in pairs(Config.IllegalActions) do
        actions[k] = v.label
    end
    SendNUIMessage({
        action = "setup",
        items = actions
    })
end)
