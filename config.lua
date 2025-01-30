Rise = {}

Rise.KaraParaNoktalari = {
    {
        coords = vector4(-124.156, -639.497, 168.82, 98.12), 
        jobs = {
            "police"
        }
    },
    {
        coords = vector4(-601.689, -721.397, 116.80, 358.5), 
        jobs = {
            "emlak2"
        }
    }
}

Rise.NpcModeli = 'cs_barry'
Rise.NpcAnimasyonu = 'WORLD_HUMAN_AA_TABLET'
Rise.TargetIcon = 'fas fa-money-bill-wave'
Rise.targettegorunenyazi = 'Paraları Akla'
Rise.qbmenuheader = 'Rise Emlak Sistemi'
Rise.qbinputheader = 'Rise Karaparalarını Boz'
Rise.qbinputlabel = 'Bozulacak Miktar'
Rise.qbinputsubmit = 'Boz'
Rise.webhook = 'webhokgir'
Rise.BotAdii = 'RiseDev'

Rise.Elevators = {
    ["Emlak Asansörü"] = {
        menuLabel = "Emlak Asansörü",
        marker = {
            type = 1,    -- Marker tipi
            size = 1.0,  -- Marker boyutu
            color = {    -- Marker rengi (RGB)
                r = 0,
                g = 157,
                b = 255,
                a = 100
            }
        },
        floors = {
            ["Giriş Kat"] = vector4(-117.61, -605.48, 36.28, 69.47), 
            ["1. Kat"] = vector4(-124.156, -639.497, 168.82, 98.12),
            ["2. Kat"] = vector4(-124.35, -639.53, 176.67, 98.12)

        }
    },

    ["Plaza Asansörü"] = {
        menuLabel = "Plaza Asansörü",
        marker = {
            type = 1,
            size = 1.0,
            color = {
                r = 255,
                g = 157,
                b = 0,
                a = 100
            }
        },
        floors = {
            ["Lobi"] = vector4(-601.689, -721.397, 116.80, 358.5),
            ["Ofis Katı"] = vector4(-601.689, -721.397, 126.80, 358.5),
            ["VIP Kat"] = vector4(-601.689, -721.397, 136.80, 358.5)
        }
    }
}

Rise.ElevatorSettings = {
    distance = 4.0,          -- asansör kullanımı mesafesi
    notifyType = "primary", -- bildirim tipi    
    sound = true,            -- ses
    helpText = "[E] Asansörü kullan", -- yardım metni
    progressBar = {
        duration = 3000,--asansör kullanımı süresi
        text = "Asansöre biniyorsun...",  -- asansöre biniyor mesajı    
        cancelText = "Asansör kullanımı iptal edildi"  -- Asansör iptal edildi mesajı

    }
}
