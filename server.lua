local QBCore = exports['qbx-core']:GetCoreObject()

lib.callback.register('qb-scoreboard:server:GetConfig', function()
    return Config.IllegalActions
end)

lib.callback.register('qb-scoreboard:server:GetScoreboardData', function()
    local totalPlayers = 0
    local policeCount = 0
    local players = {}

    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
                policeCount += 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = QBCore.Functions.IsOptin(v.PlayerData.source)
        end
    end
    return totalPlayers, policeCount, players
end)

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)