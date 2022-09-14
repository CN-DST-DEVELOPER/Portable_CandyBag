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

--自定义糖果袋属性
local candybag_data = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-5, -120, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}

for y = 0, 6 do
    table.insert(candybag_data.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(candybag_data.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

function candybag_data.itemtestfn(container, item, slot)
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

-- local function inventory_fn(Inventory)
--     local oldGetNextAvailableSlot = Inventory.GetNextAvailableSlot
--     function Inventory:GetNextAvailableSlot(item)
--         local function find_portable_bag(val)
--             return val:HasTag("portable_bag")
--         end
--         local portable_bags = self:FindItems(find_portable_bag)
--         local overflow
--         local retk
--         if portable_bags ~= nil then
--             for k, v in pairs(portable_bags) do
--                 if
--                     v.components.container ~= nil and v.components.container.canbeopened and
--                         v.components.container:IsFull() == false and
--                         v.components.container:ShouldPrioritizeContainer(item)
--                  then
--                     overflow = v.components.container
--                     break
--                 end
--             end
--             if overflow ~= nil then
--                 for k = 1, overflow:GetNumSlots() do
--                     if overflow:CanTakeItemInSlot(item, k) and not overflow.slots[k] then
--                         retk = k
--                         break
--                     end
--                 end
--             end
--         end

--         if overflow ~= nil and retk ~= nil then
--             return retk, overflow
--         else
--             return oldGetNextAvailableSlot(self, item)
--         end
--     end
-- end

-- AddComponentPostInit("inventory", inventory_fn)
