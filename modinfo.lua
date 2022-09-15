--[[ 
   
Copyright [2022] [dust_05]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
   
--]]
name = "便携糖果袋"
author = "辰暮"
description = [[
为方便节日物品的拾取、储存、使用，糖果袋不再可装备，可以放在物品栏
可设置是否装入冬季盛宴零食、冬季盛宴装饰、万圣节药剂
种子袋已同步修改
版本原因,不建议2022-09-11前的档开启
]]
version = "1.0.0"
dst_compatible = true
forge_compatible = false
gorge_compatible = false
dont_starve_compatible = false
client_only_mod = false
all_clients_require_mod = true
icon_atlas = "images/modicon.xml"
icon = "modicon.tex"
forumthread = ""
api_version_dst = 10
priority = 0
mod_dependencies = {}
server_filter_tags = {}
configuration_options = {
    {
        --GetModConfigData("winter_food")
        name = "winter_food",
        label = "冬季盛宴零食",
        hover = "糖果袋是否可装冬季盛宴零食",
        options = {
            {data = true, description = "是", hover = "可装冬季盛宴零食"},
            {data = false, description = "否", hover = "不可装冬季盛宴零食"}
        },
        default = true
    },
    {
        --GetModConfigData("winter_ornament")
        name = "winter_ornament",
        label = "冬季盛宴装饰",
        hover = "糖果袋是否可装冬季盛宴装饰",
        options = {
            {data = true, description = "是", hover = "可装冬季盛宴装饰"},
            {data = false, description = "否", hover = "不可装冬季盛宴装饰"}
        },
        default = true
    },
    {
        --GetModConfigData("halloween_potion")
        name = "halloween_potion",
        label = "万圣节药剂",
        hover = "糖果袋是否可装万圣节药剂",
        options = {
            {data = true, description = "是", hover = "可装万圣节药剂"},
            {data = false, description = "否", hover = "不可装万圣节药剂"}
        },
        default = true
    }
}
