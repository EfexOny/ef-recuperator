-- ==============VARS=============

inceput = false 
activat = false


Citizen.CreateThread(function()
    -- PlayerData management
    local PlayerData = QBCore.Functions.GetPlayerData()

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        PlayerData = nil
    end)

    RegisterNetEvent("QBCore:Client:OnJobUpdate")
    AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
        if PlayerData then
            PlayerData.job = job
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)

    RegisterNetEvent("QBCore:Client:SetDuty")
    RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
        if PlayerData.job then
            PlayerData.job.onduty = duty
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)
end)


RegisterNetEvent('ef-launder:client:notify')
AddEventHandler('ef-launder:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)

function SetupLaunderBoss()
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
        SetupLaunderBoss()
	end
end

function CreatePeds()
	SetupLaunderBoss()
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

RegisterCommand('scuba', function(_, args)
    TriggerEvent('ef-recuperator:client:scuba')
end)

RegisterNetEvent("ef-recuperator:client:scuba")
AddEventHandler("ef-recuperator:client:scuba",function()
    verificarescuba()
end)


RegisterNetEvent("ef-recuperator:client:startmis")
AddEventHandler("ef-recuperator:client:startmis",function()

    if not inceput then
        inceput = true
        targetstart()
        mesajrun()
        print("da")
    else
        targetstop()
        print(inceput)
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
    if not activat then
        local ped = GetPlayerPed(-1)
        SetPedScubaGearVariation(ped)
        activat = true
        print(activat)
    else
        local ped = GetPlayerPed(-1)
        ClearPedScubaGearVariation(ped)
        activat = false
        print(activat)
    end
end

function mesajrun()
	Citizen.Wait(2000)
	TriggerServerEvent('qb-phone:server:sendNewMail', {
	sender = ('Efex'),
	subject = ('Ai treaba de facut'),
	message = ('Du-te si foloseste autogenul sa iei obiectele din containere'),
	})
	Citizen.Wait(3000)
end