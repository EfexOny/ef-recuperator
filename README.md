# ef-recuperator
 Drag and drop the resource where you want. 
 
 Add  this in qb-core - shared - items 
```lua

 
["autogen"] 					 = {["name"] = "autogen", 			 	["label"] = "autogen", 		        ["weight"] = 100, 		["type"] = "item", 		["image"] = "package.png", 				["unique"] = false, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Cum ziceam , e un autogen"},
["setoxy"] 					 = {["name"] = "setoxy", 			 	["label"] = "setoxy", 		        ["weight"] = 1000, 		["type"] = "item", 		["image"] = "package.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "E set oxy boss"},


```


Add this in qb-smallresources server consumables.lua

```lua

QBCore.Functions.CreateUseableItem("setoxy", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:setoxy", src, "setoxy")
        TriggerEvent("ef-recuperator:client:scuba")
    end
end)
```
Add this in qb-smallresources client consumables.lua


```lua

RegisterNetEvent("consumables:client:setoxy")
AddEventHandler("consumables:client:setoxy", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    QBCore.Functions.Progressbar("search_register", "Iti pun kitul vere", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("ef-recuperator:client:scuba")
    end)
end)


```
