local Tunnel = module("vrp", "lib/Tunnel")
local serverFunctions = Tunnel.getInterface("cristian_tomates")


local inService = false

CreateThread(function()
    local ped = PlayerPedId()
    while not inService do
        local sleep = 2000
        local pedCds = GetEntityCoords(ped)
        local distance = #(pedCds - config.startJob)
        if distance <= 10 then
            sleep = 0
            DrawMarker(22, config.startJob.x, config.startJob.y, config.startJob.z - 0.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 0, 0, 255, 255, false, false, false, true)
            drawText3D(config.startJob.x, config.startJob.y, config.startJob.z + 0.3, "Pressione [~r~E~w~] para iniciar o trabalho")
            if distance <= 2 and IsControlJustPressed(0, 38) then
                startJob()
            end
        end
        Wait(sleep)
    end
end)

function startJob()
    inService = true
    local ped = PlayerPedId()
    local markerMax = #(config.markers)
    local markerRandom = math.random(1, markerMax)
    while inService do
        drawTxt("~r~Pressione F6 para encerrar o serviço!",4,0.1,0.93,0.50)
        -- drawTextOnScreen("~r~Pressione F6 para encerrar o serviço!")
        local pedCds = GetEntityCoords(ped)
        local distance = #(pedCds - config.markers[markerRandom])
        if distance <= 1 and IsControlJustPressed(0, 38) then
            markerRandom = math.random(1, markerMax)
            playAnim()
            serverFunctions.giveItem(source)
        end
        drawText3D(config.markers[markerRandom].x, config.markers[markerRandom].y, config.markers[markerRandom].z, "Pressione [~r~E~w~] para coletar")
        Wait(0)
    end
end

function playAnim()
    local ped = PlayerPedId()
    local animationName = "givetake2_b"
    local animationDictionary = "mp_common"

    repeat
        RequestAnimDict(animationDictionary)
        Wait(100)
    until HasAnimDictLoaded(animationDictionary)

    TaskPlayAnim(ped, animationDictionary, animationName, 8.0, 8.0, 2700, 11, 1.0)
end

RegisterCommand("finalizarEmpregoTomates", function()
    inService = false
end)

RegisterKeyMapping('finalizarEmpregoTomates', 'Finalizar emprego de tomates', 'keyboard', 'F6')





function drawTxt(text,font,x,y,scale)
	SetTextFont(font)
	SetTextScale(scale,scale)
	-- SetTextColour(r,g,b,a)
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