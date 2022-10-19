GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

local function ondropped(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close")
end

----------------------------------------------糖果袋----------------------------------------------
local function candybag_item_fn(container, item, slot)
    local ret1 = GetModConfigData("winter_food") and item:HasTag("wintersfeastfood")
    local ret2 = GetModConfigData("winter_ornament") and item:HasTag("winter_ornament")
    local ret3 =
        GetModConfigData("halloween_potion") and
        (string.sub(item.prefab or "", 1, 16) == "halloweenpotion_" or item.prefab == "livingtree_root")
    local ret4 = GetModConfigData("jellybean") and string.sub(item.prefab or "", 1, 9) == "jellybean"

    return item:HasTag("halloweencandy") or item:HasTag("halloween_ornament") or
        string.sub(item.prefab or "", 1, 8) == "trinket_" or
        ret1 or
        ret2 or
        ret3 or
        ret4
end

--糖果袋属性
local candybag_data = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(600, -120, 0)
    },
    issidewidget = false,
    type = "portable_bag",
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
    if TheNet:GetIsServer() then
        if inst.components.container then
            inst.components.container:WidgetSetup("candybag", candybag_data)
            inst.components.container.onopenfn = onopen
            inst.components.container.onclosefn = onclose
        end

        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = true
            inst.components.inventoryitem:SetOnDroppedFn(ondropped)
            if inst.components.equippable then
                inst:RemoveComponent("equippable")
            end
        end
    elseif TheNet:GetIsClient() then
        inst.OnEntityReplicated = function(inst)
            if inst.replica.container then
                inst.replica.container:WidgetSetup("candybag", candybag_data)
            end
        end
    end
end

AddPrefabPostInit("candybag", candybag_fn)

----------------------------------------------种子袋----------------------------------------------
if GetModConfigData("seedpouch_portable") then
    local function seedpouch_item_fn(container, item, slot)
        return item.prefab == "seeds" or string.match(item.prefab or "", "_seeds") or item:HasTag("treeseed")
    end

    --种子袋属性
    local seedpouch_data = {
        widget = {
            slotpos = {},
            animbank = "ui_krampusbag_2x8",
            animbuild = "ui_krampusbag_2x8",
            pos = Vector3(600, -120, 0)
        },
        issidewidget = false,
        type = "portable_bag",
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
        if TheNet:GetIsServer() then
            if inst.components.container then
                inst.components.container:WidgetSetup("seedpouch", seedpouch_data)
                inst.components.container.onopenfn = onopen
                inst.components.container.onclosefn = onclose
            end

            if inst.components.inventoryitem then
                inst.components.inventoryitem.cangoincontainer = true
                inst.components.inventoryitem:SetOnDroppedFn(ondropped)
                if inst.components.equippable then
                    inst:RemoveComponent("equippable")
                end
            end
        elseif TheNet:GetIsClient() then
            inst.OnEntityReplicated = function(inst)
                if inst.replica.container then
                    inst.replica.container:WidgetSetup("seedpouch", seedpouch_data)
                end
            end
        end
    end

    AddPrefabPostInit("seedpouch", seedpouch_fn)
end
