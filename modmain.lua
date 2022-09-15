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

local function candybag_item_fn(container, item, slot)
    local ret1 = GetModConfigData("冬季盛宴零食") and item:HasTag("wintersfeastfood")
    local ret2 = GetModConfigData("冬季盛宴装饰") and item:HasTag("winter_ornament")
    local ret3 =
        GetModConfigData("万圣节药剂") and
        (string.sub(item.prefab, 1, 16) == "halloweenpotion_" or item.prefab == "livingtree_root")

    return item:HasTag("halloweencandy") or item:HasTag("halloween_ornament") or
        string.sub(item.prefab, 1, 8) == "trinket_" or
        ret1 or
        ret2 or
        ret3
end

--自定义糖果袋属性
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

--糖果袋扩展逻辑
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
            end
        end
        --根据盒子名搜索玩家身上以及背包中合适的容器
        if portable_bag_name then
            local medal_boxs =
                self:FindItems(
                function(item)
                    return item.prefab == portable_bag_name and item.components.container and
                        item.components.container:IsFull() == false
                end
            )
            if #medal_boxs > 0 then
                for k, v in ipairs(medal_boxs) do
                    portable_bag_container = v.components.container
                    break
                end
            end
        end
        if portable_bag_container and portable_bag_container:GiveItem(inst, nil, src_pos) then
            return true
        end

        return oldGiveItem and oldGiveItem(self, inst, slot, src_pos)
    end
end

AddComponentPostInit("inventory", inventory_fn)
