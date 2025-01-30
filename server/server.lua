local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('RiseDev:bozKaraPara', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local markedbills = xPlayer.Functions.GetItemByName('karapara')

    if markedbills and markedbills.amount >= amount then
        xPlayer.Functions.RemoveItem('karapara', amount)
        xPlayer.Functions.AddItem('money', amount)
        TriggerClientEvent('QBCore:Notify', src, 'Kara para başarıyla bozuldu!', 'success')
        
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
        
        PerformHttpRequest(Rise.webhook, function(err, text, headers) 
            if err ~= 200 then
                print("Webhook gönderim hatası: " .. text)
            end
        end, 'POST', json.encode({
            username = Rise.BotAdii,
            embeds = {{
                color = 3447003,
                description = message,
                footer = { text = 'RiseDev Karapara' }
            }},
        }), { ['Content-Type'] = 'application/json' })
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli kara paranız yok!', 'error')
    end
end)
