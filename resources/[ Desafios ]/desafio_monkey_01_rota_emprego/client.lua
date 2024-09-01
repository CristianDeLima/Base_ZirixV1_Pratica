local Tunnel = module("vrp", "lib/Tunnel")
local fromServer = Tunnel.getInterface("desafio_monkey_01")
local webhookLink = "https://discord.com/api/webhooks/1279911446028877836/9VkzxveFAR-t7Nseoo6B-SrUOeEJqvQMGpTTfVSjLxGakYiFLEG_JKxlWkQDBLDKBjfT"
local inRoute = false
local idMarker = 1


RegisterCommand("comecarprova", function()
    if fromServer.hasGroup() then
        fromServer.SendWebhookMessageJoin(webhookLink)
        
        inRoute = true
        local sleep = 0
        local colorMarker = false
        local blip = AddBlipForCoord(config.locationMarkers[idMarker])
        SetBlipRoute(blip, true)
        while inRoute do
            drawTxt("Você está em rota\nPressione ~r~F6~w~ para sair do serviço",4,0.1,0.93,0.50)
            local ped = PlayerPedId()
            local pedCds = GetEntityCoords(ped)
            local distance = #(pedCds - config.locationMarkers[idMarker])
            if distance <= 15 then
                if distance <= 2 and IsControlJustPressed(0, 38) then
                    fromServer.getItem()
                    RemoveBlip(blip)
                    if idMarker <= 9 then
                        idMarker = idMarker + 1
                    else
                        idMarker = 1
                    end
                    blip = AddBlipForCoord(config.locationMarkers[idMarker])
                    SetBlipRoute(blip, true)
                    fromServer.giveMoney()
                end
                if idMarker <= 9 then
                    DrawMarker(22, config.locationMarkers[idMarker], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 255, true, false, false, true)
                else
                    DrawMarker(22, config.locationMarkers[idMarker], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, false, true)
                end
            end
            Wait(sleep)
        end
    else
        TriggerEvent("Notify","negado", "Você não possui permissão para usar esse comando!")
    end
end)

RegisterCommand("sairDaRota", function()
    inRoute = false
    fromServer.SendWebhookMessageLeave(webhookLink)
end)

RegisterKeyMapping("sairDaRota", "Sair da rota", "keyboard", "F6")

function drawTxt(text,font,x,y,scale)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function drawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.04, 0, 0, 0, 145)
end

RegisterCommand("tiraradministrador", function()
    TriggerServerEvent("desafio_monkey:tirargrupo")
end)