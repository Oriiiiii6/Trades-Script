RegisterServerEvent("ox_trade:startTrade", function()
    local src = source
    TriggerClientEvent("ox_trade:openMenu", src)
end)

RegisterServerEvent("ox_trade:processTrade", function(data)
    local src = source
    local inventory = exports.ox_inventory:GetInventory(src)

    if inventory then
        local hasItem = exports.ox_inventory:GetItem(src, data.giveItem)

        if hasItem and hasItem.count and hasItem.count >= data.giveAmount then
            exports.ox_inventory:RemoveItem(src, data.giveItem, data.giveAmount)
            exports.ox_inventory:AddItem(src, data.getItem, data.getAmount)

            local giveLabel = data.giveLabel or data.giveItem
            local getLabel = data.getLabel or data.getItem

            TriggerClientEvent('ox_lib:notify', src, { 
                title = 'Trade Successful', 
                description = "You traded " .. data.giveAmount .. "x " .. giveLabel .. " for " .. data.getAmount .. "x " .. getLabel, 
                type = 'success' 
            })
        else
            TriggerClientEvent('ox_lib:notify', src, { 
                title = 'Trade Failed', 
                description = "You don't have enough " .. (data.giveLabel or data.giveItem), 
                type = 'error' 
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, { 
            title = 'Trade Failed', 
            description = 'Something went wrong.', 
            type = 'error' 
        })
    end
end)
