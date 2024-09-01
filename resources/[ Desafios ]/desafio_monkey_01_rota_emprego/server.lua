local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local Tunnel = module("vrp", "lib/Tunnel")
local toClient = {}
Tunnel.bindInterface("desafio_monkey_01", toClient)

function toClient.giveMoney()
    local user_id = vRP.getUserId(source)
    vRP.giveMoney(user_id, config.valuePayment)
    TriggerClientEvent("Notify",source,"sucesso","Você recebeu R$: " .. config.valuePayment)
end

function toClient.hasGroup()
    local user_id = vRP.getUserId(source)
    local hasGroup = vRP.hasGroup(user_id,"administrador")
    return hasGroup
end

function toClient.getItem()
    local user_id = vRP.getUserId(source)
    local item = "diamante"
    local haveItem = vRP.tryGetInventoryItem(user_id, item, 1)
    if haveItem then
        TriggerClientEvent("Notify",source,"sucesso","Item " .. item .. " foi retirado da sua mochila")
    else
        TriggerClientEvent("Notify",source,"negado","Você precisa de 1 " .. item)
    end
end

function toClient.SendWebhookMessageJoin(webhook)
    local user_id = vRP.getUserId(source)
    local message = "O ID: " .. user_id .. " Entrou em serviço"
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function toClient.SendWebhookMessageLeave(webhook)
    local user_id = vRP.getUserId(source)
    local message = "O ID: " .. user_id .. " Saiu do serviço"
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterNetEvent("desafio_monkey:tirargrupo", function()
    local user_id = vRP.getUserId(source)
    if vRP.hasGroup(user_id, "mindmaster") then
        vRP.removeUserGroup(user_id, "administrador")
    else
        TriggerClientEvent("Notify",source,"negado","Você não possui permissão!")
    end
end)

RegisterCommand("adicionargrupo", function(source, args)
    local user_id = vRP.getUserId(source)
    if vRP.hasGroup(user_id,"mindmaster") then
        local group = vRP.prompt(source, "Coloque a permissão que deseja adicionar", 'administrador')
        vRP.addUserGroup(user_id, group)
    else
        TriggerClientEvent("Notify",source,"negado","Você não possui permissão!")
    end
end)