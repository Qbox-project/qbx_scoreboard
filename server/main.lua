local sharedConfig = require 'config.shared'
GlobalState.illegalActions = sharedConfig.illegalActions

lib.callback.register('qbx_scoreboard:server:getScoreboardData', function()
    local totalPlayers = 0
    local policeCount = 0
    local onDutyAdmins = {}

    for _, v in pairs(exports.qbx_core:GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
                policeCount += 1
            end

            onDutyAdmins[v.PlayerData.source] = IsPlayerAceAllowed(v.PlayerData.source, 'admin') and v.PlayerData.optin and true or nil
        end
    end

    return totalPlayers, policeCount, onDutyAdmins
end)

local function setActivityBusy(name, bool)
    local illegalActions = GlobalState.illegalActions
    illegalActions[name].busy = bool
    GlobalState.illegalActions = illegalActions
end
RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', setActivityBusy)
exports('SetActivityBusy', setActivityBusy)
