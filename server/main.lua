local config = require 'config.server'
GlobalState.illegalActions = config.illegalActions

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

            onDutyAdmins[v.PlayerData.source] = IsPlayerAceAllowed(v.PlayerData.source, 'admin') and v.PlayerData.metadata.optin and true or nil
        end
    end

    return totalPlayers, policeCount, onDutyAdmins
end)

local function setActivityBusy(name, bool)
    if type(name) ~= 'string' or type(bool) ~= 'boolean' then return end

    local illegalActions = GlobalState.illegalActions
    if not illegalActions[name] then return end

    illegalActions[name].busy = bool
    GlobalState.illegalActions = illegalActions
end

---@deprecated use the setActivityBusy export instead
AddEventHandler('qb-scoreboard:server:SetActivityBusy', setActivityBusy)
exports('SetActivityBusy', setActivityBusy)
