local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, location in pairs(Rise.KaraParaNoktalari) do
        local model = GetHashKey(Rise.NPC.Model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        local npc = CreatePed(4, model, location.coords.x, location.coords.y, location.coords.z - 1.0, location.coords.w, false, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskStartScenarioInPlace(npc, Rise.NPC.Animasyonu, 0, true)
        FreezeEntityPosition(npc, true)
        exports[Rise.Target.Export]:AddTargetEntity(npc, {
            options = {
                {
                    type = "client",
                    event = "RiseDev:openMenu",
                    icon = Rise.Target.Icon,
                    label = Rise.Target.LabelYazi,
                    job = location.jobs
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('RiseDev:openMenu', function()
    exports[Rise.Menu.Export]:openMenu({
        {
            header = Rise.Menu.Header,
            isMenuHeader = true
        },
        {
            header = Rise.Menu.DepoHeader,
            txt = Rise.Menu.DepoTXT,
            params = {
                event = "RiseDev:openStash"
            }
        },
        {
            header = Rise.Menu.BozHeader,
            txt = Rise.Menu.BozTXT,
            params = {
                event = "RiseDev:bozmaInput"
            }
        },
        {
            header = Rise.Menu.Kapat,
            params = {
                event = "qb-menu:closeMenu"
            }
        }
    })
end)

RegisterNetEvent('RiseDev:openStash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "karaParaDeposu", {
        maxweight = Rise.Depo.Agirlik,
        slots = Rise.Depo.Slot,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "karaParaDeposu")
end)

RegisterNetEvent('RiseDev:bozmaInput', function()
    local dialog = exports[Rise.Input.Export]:ShowInput({
        header = Rise.Input.Header,
        submitText = Rise.Input.Submit,
        inputs = {
            {
                text = Rise.Input.Label,
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })

    if dialog and dialog.amount then
        TriggerServerEvent('RiseDev:bozKaraPara', tonumber(dialog.amount))
    else
        QBCore.Functions.Notify(Locale.Notify.Fakir, "error")
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false

        for elevatorName, elevatorData in pairs(Rise.Elevators) do
            for floorName, coords in pairs(elevatorData.floors) do
                local dist = #(pos - vector3(coords.x, coords.y, coords.z))
                
                if dist < 10.0 then
                    sleep = 0
                    DrawMarker(
                        elevatorData.marker.type,
                        coords.x, coords.y, coords.z - 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        elevatorData.marker.size, elevatorData.marker.size, elevatorData.marker.size,
                        elevatorData.marker.color.r, elevatorData.marker.color.g, elevatorData.marker.color.b, elevatorData.marker.color.a,
                        false, false, 2, false, nil, nil, false
                    )

                    if dist < Rise.ElevatorSettings.distance then
                        inRange = true
                        ShowHelpNotification(Rise.ElevatorSettings.helpText)

                        if IsControlJustReleased(0, 38) then
                            OpenElevatorMenu(elevatorName, elevatorData)
                        end
                    end
                end
            end
        end

        if not inRange then
            sleep = 1000
        end
        Wait(sleep)
    end
end)

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function OpenElevatorMenu(elevatorName, elevatorData)
    local menuItems = {
        {
            header = elevatorData.menuLabel,
            isMenuHeader = true
        }
    }

    for floorName, coords in pairs(elevatorData.floors) do
        table.insert(menuItems, {
            header = floorName,
            txt = Rise.Asansor.MenuTXT,
            params = {
                event = "RiseDev:useElevator",
                args = {
                    coords = coords,
                    floorName = floorName,
                    elevatorName = elevatorName
                }
            }
        })
    end

    table.insert(menuItems, {
        header = Rise.Asansor.Header,
        params = {
            event = "qb-menu:closeMenu"
        }
    })

    exports[Rise.Asansor.Export]:openMenu(menuItems)
end

RegisterNetEvent('RiseDev:useElevator', function(data)
    local ped = PlayerPedId()
    
    if Rise.ElevatorSettings.sound then
        PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    end

    QBCore.Functions.Progressbar("beqeendAsansorKeeee", 
        Rise.ElevatorSettings.progressBar.text, 
        Rise.ElevatorSettings.progressBar.duration, 
        false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@apt_trans@elevator",
            anim = "elev_1",
            flags = 16,
        }, {}, {}, function()
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do Wait(10) end
            
            SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z - 1.0)
            SetEntityHeading(ped, data.coords.w)
            
            Wait(100)
            DoScreenFadeIn(500)
            
            QBCore.Functions.Notify(data.floorName .. " katına ulaştınız", Rise.ElevatorSettings.notifyType)
        end, function()
            QBCore.Functions.Notify(Rise.ElevatorSettings.progressBar.cancelText, "error")
        end)
end)
