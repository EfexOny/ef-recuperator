-- ==============VARS=============

inceput = false 
activat = false
markda = true

-- ==========THREADS===============

RegisterNetEvent('ef-recuperator:client:notify')
AddEventHandler('ef-recuperator:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)

function SetupBoss()
	BossHash = Config.ped[math.random(#Config.ped)]
	loc = Config.location[math.random(#Config.location)]
	QBCore.Functions.LoadModel(BossHash)
    Boss = CreatePed(0, BossHash, loc.x, loc.y, loc.z-1.0, loc.w, false, false)
    SetPedFleeAttributes(Boss, 0, 0)
    SetPedDiesWhenInjured(Boss, false)
    TaskStartScenarioInPlace(Boss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetPedKeepTask(Boss, true)
    SetBlockingOfNonTemporaryEvents(Boss, true)
    SetEntityInvincible(Boss, true)
    FreezeEntityPosition(Boss, true)
end

function DeleteBoss()
    local player = PlayerPedId()
	if DoesEntityExist(Boss) then
        ClearPedTasks(Boss) 
		ClearPedTasksImmediately(Boss)
        ClearPedSecondaryTask(Boss)
        FreezeEntityPosition(Boss, false)
        SetEntityInvincible(Boss, false)
        SetBlockingOfNonTemporaryEvents(Boss, false)
        TaskReactAndFleePed(Boss, player)
		SetPedAsNoLongerNeeded(Boss)
		Wait(8000)
		DeletePed(Boss)
        SetupBoss()
	end
end

function CreatePeds()
	SetupBoss()
end

CreateThread(function()
    CreatePeds()
end)


CreateThread(function()
    if not inceput then
        exports['qb-target']:AddTargetModel(Config.ped,  {
            options = {
                { 
                    type = "client", 
                    event = "ef-recuperator:client:startmis",
                    icon = "fas fa-id-card",
                    label = ("Start doing the work"),
                },
                
            },
            distance = 3.0 
        })
    elseif inceput then
        TriggerEvent("ef-recuperator:client:removetarget")
        exports['qb-target']:AddTargetModel(Config.ped, {
            options = {
                { 
                    type = "client", 
                    event = "ef-recuperator:client:startmis",
                    icon = "fas fa-id-card",
                    label = ("Stop working"),
                },
                
            },
            distance = 3.0 
        })
    end


end)

RegisterNetEvent('ef-recuperator:client:start', function()
	exports['qb-target']:RemoveTargetModel(Config.ped, {
		("Start doing the work"),
	})

end)


RegisterNetEvent('ef-recuperator:client:stop', function()
	exports['qb-target']:RemoveTargetModel(Config.ped, {
		("Stop working"),
	})

end)


RegisterNetEvent("ef-recuperator:client:scuba")
AddEventHandler("ef-recuperator:client:scuba",function()
    verificarescuba()
end)

RegisterCommand('scoatescuba', function(_, args)
    TriggerEvent('ef-recuperator:client:scoatescuba')
end)


RegisterNetEvent("ef-recuperator:clinet:scoatescuba")
AddEventHandler("ef-recuperator:client:scoatescuba",function()
    local ped = GetPlayerPed(-1)
    ClearPedScubaGearVariation(ped)
    DeleteEntity(scubaEntity)
    DeleteObject(scuba)
    DeleteObject(scubaEntity)
    SetPedDiesInWater(ped,true)
    ClearAllPedProps(ped)
end)



RegisterNetEvent("ef-recuperator:client:startmis")
AddEventHandler("ef-recuperator:client:startmis",function()

    if not inceput then
        inceput = true
        targetstart()
        mesajrun()
        generatlocuri()
    else
        targetstop()
        cleanup()
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName()
    then
			exports['qb-target']:RemoveTargetModel(Config.ped, {
				("Stop working")
			})

			exports['qb-target']:RemoveTargetModel(Config.ped, {
				("Start doing the work")
			})

            cleanup()            

        end
    end)



-- ==================FUNCTII================

function targetstart()
    TriggerEvent("ef-recuperator:client:start")
    exports['qb-target']:AddTargetModel(Config.ped, {
        options = {
            { 
                type = "client", 
                event = "ef-recuperator:client:startmis",
                icon = "fas fa-id-card",
                label = ("Stop working"),
            },
            
        },
        distance = 3.0 
    })
end

function targetstop()
    TriggerEvent("ef-recuperator:client:stop")
    exports['qb-target']:AddTargetModel(Config.ped, {
        options = {
            { 
                type = "client", 
                event = "ef-recuperator:client:startmis",
                icon = "fas fa-id-card",
                label = ("Start doing the work"),
            },
            
        },
        distance = 3.0 
    })
end

function verificarescuba()
    ped = GetPlayerPed(-1)
    prop = "p_s_scuba_tank_s"
    pedPos = GetEntityCoords(ped, false)
    scuba = CreateObject(GetHashKey(prop),pedPos.x , pedPos.y,pedPos.z,1,1,1)
    scubaEntity = scuba 

    if not activat then
        AttachEntityToEntity(scubaEntity,ped,GetPedBoneIndex(GetPlayerPed(-1), 24818), -0.30, -0.20, -0.010, 0, 90.0, -180.0, true, true, false, true, 1, true)  
        SetEnableScuba(ped)
        SetPedScubaGearVariation(ped)
        SetPedDiesInWater(ped,false)
        activat = true
    else
        TriggerEvent("ef-recuperator:clinet:scoatescuba")
        activat = false
    end
end



function mesajrun()
	Citizen.Wait(2000)
	TriggerServerEvent('qb-phone:server:sendNewMail', {
	sender = (Config.sender),
	subject = (Config.subject),
	message = (Config.message),
	})
	Citizen.Wait(3000)
end

RegisterNetEvent("ef-recuperator:client:autogen")
AddEventHandler("ef-recuperator:client:autogen",function()
    autogen()
    markda = false
end)

function autogen()
    local hasItem = QBCore.Functions.HasItem("autogen")
    local ped = GetPlayerPed(-1)
    
    if hasItem then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 10000, true)
        QBCore.Functions.Progressbar("search_register", ("Ii dam cu autogenu boss imd"), 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
        }, {}, {}, function() 
        end)
        Wait(10000)
        ClearPedTasksImmediately(ped)
        generatlocuri()
        
        
        if math.random(1,100) <= Config.destroy then
            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["autogen"], "remove")
            TriggerServerEvent("ef-recuperator:server:remove")
            TriggerEvent('ef-recuperator:client:notify', "Ti s-a stricat autogenul!", 'error')
        end

        if math.random(1,100) <= Config.reward then
            TriggerServerEvent("ef-recuperator:server:reward")    
            TriggerEvent('ef-recuperator:client:notify', "Ai gasit ceva !", 'success')
        else
            TriggerEvent('ef-recuperator:client:notify', "N-ai gasit nimic.", 'error')
        end
    else
        TriggerEvent('ef-recuperator:client:notify', "N-ai autogen la tine babalaule!", 'error')
    end
end


RegisterCommand('generatloc', function(_, args)
    generatlocuri()
end)

function generatlocuri()
    cleanup()
    markda = true
    local locat = math.random(#Config.locatii)
    local mark = Config.locatii[locat]
    exports['qb-target']:AddCircleZone("container", Config.locatii[locat],2.0, {
        name = "container",
        heading = 0,
        useZ = true,
        -- debugPoly = true,
    }, {
        options = {
            {
                type = "client",
                event = "ef-recuperator:client:autogen",
                icon = "fa-solid fa-money-bill-wave",
                label = "Use it",
            },
        },
        distance = 2.5
    })
    ped= GetPlayerPed(-1)
    pos = GetEntityCoords(ped)

    -- vector3(3165.97, -331.66, -23.41)
    
        while (math.abs(mark.x - pos.x) > 1 or math.abs(mark.y - pos.y) > 1 or math.abs(mark.z - pos.z) > 1) do
            Wait(1)
            DrawMarker(2, mark.x,mark.y,mark.z,0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
    end
end

function cleanup()
    markda = false
    exports['qb-target']:RemoveZone('container')
end
