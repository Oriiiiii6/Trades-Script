local lib = exports.ox_lib

CreateThread(function()
    for _, location in pairs(Config.TradeLocations) do
        RequestModel(location.model)
        while not HasModelLoaded(location.model) do
            Wait(100)
        end

        local ped = CreatePed(4, location.model, location.coords.x, location.coords.y, location.coords.z - 1.0, 0.0, false, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local showText = false

        for _, location in pairs(Config.TradeLocations) do
            local dist = #(playerCoords - location.coords)
            if dist < Config.InteractDistance then
                showText = true
                sleep = 0

                if IsControlJustPressed(0, 38) then 
                    TriggerServerEvent("ox_trade:startTrade")
                end
            end
        end

        if showText then
            exports.ox_lib:showTextUI("[E] Trade Exchange rare items for rewards!\n💰 ", {
                position = "right-center",
                icon = "handshake",
                style = {
                    borderRadius = 10,
                    backgroundColor = "#121212",
                    color = "#ffffff",
                    padding = "10px",
                    fontSize = "14px",
                    fontWeight = "bold"
                }
            })
        else
            exports.ox_lib:hideTextUI()
        end

        Wait(sleep)
    end
end)

RegisterNetEvent("ox_trade:openMenu", function()
    local menuOptions = {}

    for _, trade in pairs(Config.Trades) do
        table.insert(menuOptions, {
            title = trade.giveLabel .. " → " .. trade.getLabel,
            description = "Give " .. trade.giveAmount .. "x " .. trade.giveLabel .. " to receive " .. trade.getAmount .. "x " .. trade.getLabel,
            event = "ox_trade:tradeItem",
            args = { 
                giveItem = trade.giveItem, 
                giveAmount = trade.giveAmount, 
                giveLabel = trade.giveLabel, 
                getItem = trade.getItem, 
                getAmount = trade.getAmount, 
                getLabel = trade.getLabel  
            }
        })
    end

    exports.ox_lib:registerContext({
        id = "trade_menu",
        title = "Trading Menu",
        options = menuOptions
    })

    exports.ox_lib:showContext("trade_menu")
end)

RegisterNetEvent("ox_trade:tradeItem", function(data)
    TriggerServerEvent("ox_trade:processTrade", {
        giveItem = data.giveItem,
        giveAmount = data.giveAmount,
        giveLabel = data.giveLabel, 
        getItem = data.getItem,
        getAmount = data.getAmount,
        getLabel = data.getLabel  
    })
end)
