local QBCore = exports['qb-core']:GetCoreObject()

local Enabled = false

CreateThread(function()
    while QBCore == nil do
        Wait(1)
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
    end

    while not QBCore.Functions.GetPlayerData().job do
        Wait(1)
    end

    TriggerServerEvent("qb-activeofficers:officers:refresh")
end)

-- Refresh Menu --
CreateThread(function()
    while true do
        Wait(3000)
        TriggerServerEvent("qb-activeofficers:officers:refresh")
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        xPlayer = QBCore.Functions.GetPlayerData()
        if xPlayer.job.name ~= "police" then
            SendNUIMessage({ ['action'] = "close" })
        end
    end

    TriggerServerEvent("qb-activeofficers:officers:refresh")
end)

RegisterNetEvent("qb-activeofficers:officers:open")
AddEventHandler("qb-activeofficers:officers:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ ['action'] = 'close' })
            print("close")
        else
            Enabled = true
            SendNUIMessage({ ['action'] = 'open' })
            print("open")
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ ['action'] = 'drag' })
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("qb-activeofficers:officers:refresh")
AddEventHandler("qb-activeofficers:officers:refresh", function(data)
    SendNUIMessage({ ['action'] = 'refresh', ['data'] = data })
end)
