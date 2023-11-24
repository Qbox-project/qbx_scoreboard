local sharedConfig = require 'config.shared'

lib.callback.register('qbx_scoreboard:server:getConfig', function()
    return sharedConfig.illegalActions
end)

lib.callback.register('qbx_scoreboard:server:getScoreboardData', function()
    local totalPlayers = 0
    local policeCount = 0
    local players = {}

    for _, v in pairs(exports.qbx_core:GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
                policeCount += 1
            end

            players[v.PlayerData.source] = {isOnDutyAdmin = IsPlayerAceAllowed(v.PlayerData.source, 'admin') and v.PlayerData.optin}
        end
    end
    return totalPlayers, policeCount, players
end)

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    sharedConfig.illegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)
