local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local Tunnel = module("vrp", "lib/Tunnel")
local functions = {}
Tunnel.bindInterface("cristian_tomates", functions)


function functions.giveItem()
    local user_id = vRP.getUserId(source)
    local quantityItem = math.random(config.quantiyMin, config.quantiyMax)
    local itemWeight = vRP.getItemWeight("tomatinho") * quantityItem
    local backPackWeight = vRP.getInventoryWeight(user_id)
    if backPackWeight <= itemWeight then
        local isTomatinhos = " Tomatinhos"
        if quantityItem == 1 then
            isTomatinhos = " Tomatinho"
        end
        vRP.giveInventoryItem(user_id,"tomatinho", quantityItem)
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu " .. quantityItem .. isTomatinhos)
    else
        TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
    end
end
