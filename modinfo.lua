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
为方便节日物品的拾取、储存、使用, 糖果袋不再可装备, 可以放在背包箱子等物品栏
可设置是否能装入冬季盛宴零食、冬季盛宴装饰、万圣节药剂、糖豆
种子袋已同样成为便携袋子
]]
version = "1.0.4"
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

local function Subtitle(name)
    return {
        name = name,
        label = name,
        options = {{description = "", data = false}},
        default = false
    }
end

configuration_options = {
    Subtitle("糖果袋"),
    {
        name = "winter_food",
        label = "冬季盛宴零食",
        hover = "能否装冬季盛宴零食",
        options = {
            {data = true, description = "是", hover = "可装冬季盛宴零食"},
            {data = false, description = "否", hover = "不可装冬季盛宴零食"}
        },
        default = true
    },
    {
        name = "winter_ornament",
        label = "冬季盛宴装饰",
        hover = "能否装冬季盛宴装饰",
        options = {
            {data = true, description = "是", hover = "可装冬季盛宴装饰"},
            {data = false, description = "否", hover = "不可装冬季盛宴装饰"}
        },
        default = true
    },
    {
        name = "halloween_potion",
        label = "万圣节药剂",
        hover = "能否装万圣节药剂",
        options = {
            {data = true, description = "是", hover = "可装万圣节药剂"},
            {data = false, description = "否", hover = "不可装万圣节药剂"}
        },
        default = true
    },
    {
        name = "jellybean",
        label = "糖豆",
        hover = "能否装糖豆",
        options = {
            {data = true, description = "是", hover = "可装糖豆"},
            {data = false, description = "否", hover = "不可装糖豆"}
        },
        default = true
    },
    Subtitle("种子袋"),
    {
        name = "seedpouch_portable",
        label = "便携种子袋",
        hover = "是否将种子袋变为便携袋子",
        options = {
            {data = true, description = "是", hover = "变为便携袋子"},
            {data = false, description = "否", hover = "不做改动"}
        },
        default = true
    }
}
