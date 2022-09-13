--[[ 
   
Copyright [2022] [dust_05]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
   
]] --
-- 名称
name = "便携糖果袋"
-- 描述
description = "为方便节日物品的拾取、储存、使用。糖果袋不再可装备，可以放在物品栏，可设置是否装入冬季盛宴零食、冬季盛宴装饰、万圣节药剂"
-- 作者
author = "dust_05"
-- 版本
version = "0.2"

forumthread = ""

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"
-- dst兼容
dst_compatible = true
-- 是否是客户端mod
client_only_mod = false
-- 是否是所有客户端都需要安装
all_clients_require_mod = true
-- 饥荒api版本，固定填10
api_version = 10

configuration_options = {
    {
        name = "冬季盛宴零食", -- 配置项名换，在modmain.lua里获取配置值时要用到
        hover = "糖果袋是否可装冬季盛宴零食", -- 鼠标移到配置项上时所显示的信息
        options = {
            {
                description = "是", -- 可选项上显示的内容
                hover = "可装冬季盛宴零食", -- 鼠标移动到可选项上显示的信息
                data = true -- 可选项选中时的值，在modmain.lua里获取到的值就是这个数据，类型可以为整形，布尔，浮点，字符串
            },
            {
                description = "否",
                hover = "不可装冬季盛宴零食",
                data = false
            }
        },
        default = true -- 默认值，与可选项里的值匹配作为默认值
    },
    {
        name = "冬季盛宴装饰",
        hover = "糖果袋是否可装冬季盛宴装饰",
        options = {
            {
                description = "是",
                hover = "可装冬季盛宴装饰",
                data = true
            },
            {
                description = "否",
                hover = "不可装冬季盛宴装饰",
                data = false
            }
        },
        default = true
    },
    {
        name = "万圣节药剂",
        hover = "糖果袋是否可装万圣节药剂",
        options = {
            {
                description = "是",
                hover = "可装万圣节药剂",
                data = true
            },
            {
                description = "否",
                hover = "不可装万圣节药剂",
                data = false
            }
        },
        default = true
    }
}
