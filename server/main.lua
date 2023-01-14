RegisterNetEvent("ef-recuperator:server:remove")
AddEventHandler("ef-recuperator:server:remove",function() 
    local ply = QBCore.Functions.GetPlayer(source)

    ply.Functions.RemoveItem("autogen", 1)

end)

RegisterNetEvent("ef-recuperator:server:reward")
AddEventHandler("ef-recuperator:server:reward",function() 
    local ply = QBCore.Functions.GetPlayer(source)

    ply.Functions.AddItem(Config.items[math.random(#Config.items)], 1)

end)