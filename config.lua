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

Rise.ParaItem = {
    KaraPara = 'karapara',
    Para = 'money',
}
Rise.NPC = {
    Model = 'cs_barry',
    Animasyonu = 'WORLD_HUMAN_AA_TABLET',
}


Rise.Target = {
    Export = 'qb-target',
    Icon = 'fas fa-money-bill-wave',
    LabelYazi = 'Paraları Akla'
}

Rise.Menu = {
    Export = 'qb-menu',
    Header = 'Rise Emlak Sistemi',
    DepoHeader = '📦 Depoyu Aç',
    DepoTXT = 'Depoya erişim sağla.',
    BozHeader = '💰 Para Boz',
    BozTXT = 'Kara paranı nakite çevir.',
    Kapat = '⬅️ Kapat',
}

Rise.Depo = {
    Agirlik = 4000000,
    Slot = 150,
}

Rise.Input = {
    Export = 'qb-input',
    Header = 'Rise Karaparalarını Boz',
    Submit = 'Boz',
    Label = 'Bozulacak Miktar',
}




Rise.Elevators = {
    ["Emlak Asansörü"] = {
        menuLabel = "Emlak Asansörü",
        marker = {
            type = 1,   
            size = 1.0, 
            color = {   
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
    distance = 4.0,         
    notifyType = "primary", 
    sound = true,           
    helpText = "[E] Asansörü kullan",
    progressBar = {
        duration = 3000,
        text = "Asansöre biniyorsun...",  
        cancelText = "Asansör kullanımı iptal edildi"
    }
}

Rise.Asansor = {
    MenuTXT = "Bu kata git",
    Header = "⬅️ Kapat",
    Export = 'qb-menu'
}
