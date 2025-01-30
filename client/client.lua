local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, location in pairs(Rise.KaraParaNoktalari) do
        local model = GetHashKey(Rise.NpcModeli)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        local npc = CreatePed(4, model, location.coords.x, location.coords.y, location.coords.z - 1.0, location.coords.w, false, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskStartScenarioInPlace(npc, Rise.NpcAnimasyonu, 0, true)
        FreezeEntityPosition(npc, true)
        exports['qb-target']:AddTargetEntity(npc, {
            options = {
                {
                    type = "client",
                    event = "RiseDev:openMenu",
                    icon = Rise.TargetIcon,
                    label = Rise.targettegorunenyazi,
                    job = location.jobs
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('RiseDev:openMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = Rise.qbmenuheader,
            isMenuHeader = true
        },
        {
            header = "📦 Depoyu Aç",
            txt = "Depoya erişim sağla.",
            params = {
                event = "RiseDev:openStash"
            }
        },
        {
            header = "💰 Para Boz",
            txt = "Kara paranı nakite çevir.",
            params = {
                event = "RiseDev:bozmaInput"
            }
        },
        {
            header = "⬅️ Kapat",
            params = {
                event = "qb-menu:closeMenu"
            }
        }
    })
end)

RegisterNetEvent('RiseDev:openStash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "karaParaDeposu", {
        maxweight = 4000000,
        slots = 150,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "karaParaDeposu")
end)

RegisterNetEvent('RiseDev:bozmaInput', function()
    local dialog = exports['qb-input']:ShowInput({
        header = Rise.qbinputheader,
        submitText = Rise.qbinputsubmit,
        inputs = {
            {
                text = Rise.qbinputlabel,
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })

    if dialog and dialog.amount then
        TriggerServerEvent('RiseDev:bozKaraPara', tonumber(dialog.amount))
    else
        QBCore.Functions.Notify("Üzerinizde kara para bulunmuyor!", "error")
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
            txt = "Bu kata git",
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
        header = "⬅️ Kapat",
        params = {
            event = "qb-menu:closeMenu"
        }
    })

    exports['qb-menu']:openMenu(menuItems)
end

RegisterNetEvent('RiseDev:useElevator', function(data)
    local ped = PlayerPedId()
    
    if Rise.ElevatorSettings.sound then
        PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    end

    QBCore.Functions.Progressbar("elevator_travel", 
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
