GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

--丢下
local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

----------------------------------------------糖果袋----------------------------------------------
local function candybag_item_fn(container, item, slot)
    local ret1 = GetModConfigData("winter_food") and item:HasTag("wintersfeastfood")
    local ret2 = GetModConfigData("winter_ornament") and item:HasTag("winter_ornament")
    local ret3 =
    GetModConfigData("halloween_potion") and
        (string.sub(item.prefab or "", 1, 16) == "halloweenpotion_" or item.prefab == "livingtree_root")

    return item:HasTag("halloweencandy") or item:HasTag("halloween_ornament") or
        string.sub(item.prefab or "", 1, 8) == "trinket_" or
        ret1 or
        ret2 or
        ret3
end

--糖果袋属性
local candybag_data = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-140, -120, 0)
    },
    issidewidget = true,
    type = "medal_box",
    openlimit = 1
}

for y = 0, 6 do
    table.insert(candybag_data.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(candybag_data.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

candybag_data.itemtestfn = candybag_item_fn
candybag_data.priorityfn = candybag_data.itemtestfn

--糖果袋修改逻辑
local function candybag_fn(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    if inst.components.container then
        inst.components.container:WidgetSetup("candybag", candybag_data)
    end

    if inst.components.inventoryitem then
        inst.components.inventoryitem.cangoincontainer = true
        inst.components.inventoryitem:SetOnDroppedFn(ondropped)
        if inst.components.equippable then
            -- inst:AddTag("portable_bag")
            inst:RemoveComponent("equippable")
        end
    end
end

AddPrefabPostInit("candybag", candybag_fn)

----------------------------------------------种子袋----------------------------------------------
local function seedpouch_item_fn(container, item, slot)
    return item.prefab == "seeds" or string.match(item.prefab or "", "_seeds") or item:HasTag("treeseed")
end

--种子袋属性
local seedpouch_data = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-140, -120, 0)
    },
    issidewidget = true,
    type = "medal_box",
    openlimit = 1
}

for y = 0, 6 do
    table.insert(seedpouch_data.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(seedpouch_data.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

seedpouch_data.itemtestfn = seedpouch_item_fn
seedpouch_data.priorityfn = seedpouch_data.itemtestfn

--种子袋修改逻辑
local function seedpouch_fn(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    if inst.components.container then
        inst.components.container:WidgetSetup("seedpouch", seedpouch_data)
    end

    if inst.components.inventoryitem then
        inst.components.inventoryitem.cangoincontainer = true
        inst.components.inventoryitem:SetOnDroppedFn(ondropped)
        if inst.components.equippable then
            -- inst:AddTag("portable_bag")
            inst:RemoveComponent("equippable")
        end
    end
end

AddPrefabPostInit("seedpouch", seedpouch_fn)

----------------------------------------------优先级----------------------------------------------
--参考能力勋章(优先入盒)
local function inventory_fn(self)
    local oldGiveItem = self.GiveItem
    self.GiveItem = function(self, inst, slot, src_pos)
        if inst.components.inventoryitem == nil or not inst:IsValid() then
            print("Warning: Can't give item because it's not an inventory item.")
            return
        end

        local eslot = self:IsItemEquipped(inst)

        if eslot then
            self:Unequip(eslot)
        end

        local new_item = inst ~= self.activeitem
        if new_item then
            for k, v in pairs(self.equipslots) do
                if v == inst then
                    new_item = false
                    break
                end
            end
        end

        if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
            inst.components.inventoryitem:RemoveFromOwner(true)
        end

        local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
        if objectDestroyed then
            return
        end

        --模组容器
        local portable_bag_container = nil
        local portable_bag_name = nil

        if not slot then --没有目标格子才需要执行优先入盒逻辑
            --是否符合模组容器条件，选择模组容器
            if candybag_item_fn(nil, inst, nil) then
                portable_bag_name = "candybag"
            elseif seedpouch_item_fn(nil, inst, nil) then
                portable_bag_name = "seedpouch"
            end
        end
        --根据容器名搜索玩家身上以及背包中合适的容器
        if portable_bag_name then
            local portable_bags =
            self:FindItems(
                function(item)
                    return item.prefab == portable_bag_name and item.components.container and
                        item.components.container:IsFull() == false
                end
            )
            if #portable_bags > 0 then
                for k, v in ipairs(portable_bags) do
                    portable_bag_container = v.components.container
                    break
                end
            end
        end

        return oldGiveItem and oldGiveItem(self, inst, slot, src_pos)
    end
end

AddComponentPostInit("inventory", inventory_fn)
