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
