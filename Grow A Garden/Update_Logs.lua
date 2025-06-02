_G.Main = {
    hub_name = "PrimeXploit",
    owner = "PrimeX_GG",
    discord_link = "https://discord.gg/dbnuRpY2"
}

_G.script_setting = {
    Owner = _G.Main.owner,
    Name = "Grow a Garden",
    Hub_Name = _G.Main.hub_name,
    Discord_Link = _G.Main.discord_link,
    Save_File = "/Grow_a_Garden.json",

    Update_Date = "2 / 6 / 25",
    Update_Logs = {
        {
            Date = "2 / 6 / 25",
            Content = {
                ["Added"] = {
                    "Auto feed pets"
                },
                ["Remove"] = {

                },
                ["Fixed"] = {
                    "Auto sell fruit not working [ Mobile ]"
                }
            }
        },
        {
            Date = "1 / 6 / 25",
            Content = {
                ["Added"] = {
                    "Auto sell pet",
                    "Auto Swarm event",
                    "Auto favorite"
                },
                ["Remove"] = {
                    "Auto Night event"
                },
                ["Fixed"] = {
                    "Harvest very laggy",
                    "Auto buy egg not working"
                }
            }
        },
        {
            Date = "31 / 5 / 25",
            Content = {
                ["Added"] = {

                },
                ["Remove"] = {

                },
                ["Fixed"] = {
                    "Can't place egg",
                    "Can't plant seed",
                    "Can't harvest"
                }
            }
        },
    }
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/WhatTheSavage/Lua/refs/heads/main/Grow%20A%20Garden/Script.lua'))()
