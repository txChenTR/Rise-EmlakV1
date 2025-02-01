local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('RiseDev:bozKaraPara', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local markedbills = xPlayer.Functions.GetItemByName(Rise.ParaItem.KaraPara)

    if not amount or amount <= 0 then
        exports[FiveGuardDosyaAdi]:fg_BanPlayer(src, BanMesaJi, true)
        DropPlayer(src, 'Siktir Git Amk Hadii İşine \n Yetkili : Rise Development')
        return
    end

    if not markedbills or markedbills.amount < amount then
        exports[FiveGuardDosyaAdi]:fg_BanPlayer(src, BanMesaJi, true)
        DropPlayer(src, 'Siktir Git Amk Hadii İşine \n Yetkili : Rise Development')
        return
    end

    local oldMoney = xPlayer.Functions.GetItemByName(Rise.ParaItem.Para) and xPlayer.Functions.GetItemByName(Rise.ParaItem.Para).amount or 0
    local oldBlackMoney = markedbills.amount

    xPlayer.Functions.RemoveItem(Rise.ParaItem.KaraPara, amount)
    xPlayer.Functions.AddItem(Rise.ParaItem.Para, amount)

    local newMoney = xPlayer.Functions.GetItemByName(Rise.ParaItem.Para) and xPlayer.Functions.GetItemByName(Rise.ParaItem.Para).amount or 0
    local newBlackMoney = xPlayer.Functions.GetItemByName(Rise.ParaItem.KaraPara) and xPlayer.Functions.GetItemByName(Rise.ParaItem.KaraPara).amount or 0

    if (newMoney > oldMoney + amount) or (newBlackMoney > oldBlackMoney - amount) then
        exports[FiveGuardDosyaAdi]:fg_BanPlayer(src, BanMesaJi, true)
        return
    end

    local playerName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    local identifiers = GetPlayerIdentifiers(src)
    local steamHex, discordID
    for _, v in pairs(identifiers) do
        if string.find(v, "steam:") then
            steamHex = v:gsub("steam:", "")
        elseif string.find(v, "discord:") then
            discordID = v:gsub("discord:", "")
        end
    end
    local playerID = src
    local currentTime = os.date('%Y-%m-%d %H:%M:%S')

    local message = string.format("**Kara Para Bozma İşlemi**\n\n**Ad Soyad:** %s\n**Oyun ID:** %d\n**Discord ID:** <@%s>\n**Steam Hex:** %s\n**Bozulan Miktar:** $%d\n**Tarih/Saat:** %s",
        playerName, playerID, discordID, steamHex, amount, currentTime)

    PerformHttpRequest(Webhook, function(err, text, headers)
        if err ~= 200 then
           -- print("Webhook gönderim hatası: " .. text)
        end
    end, 'POST', json.encode({
        username = WebhookBotAdi,
        embeds = {{
            color = 3447003,
            description = message,
            footer = { text = 'RiseDev Karapara' }
        }},
    }), { ['Content-Type'] = 'application/json' })

    TriggerClientEvent('QBCore:Notify', src, Locale.Notify.BasariBozuldu, 'success')
end)
