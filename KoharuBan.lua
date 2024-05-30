--[[
   Copyright 2024. KoharuBan Project. ALL RIGHTS RESERVED
                Github@daisukiKaffuChino
                  Apache-2.0 Licensed
--]] 

-- 配置读写模块
mConfig = require("plugins/KoharuBan/ConfigModule")()

local function punish(player, itemType, count) -- 惩罚
    if mConfig.isPunish then
        price = mConfig.bannedItemsPrice[itemType:match("minecraft:(.+)")]
        if price then
            compensation = price * count
            player:addMoney(compensation)
            -- player:reduceMoney(compensation)
            player:setTitle(" ", 2)
            msgContent = string.format("清除了 %s * %d ， 补偿：$%d", itemType, count, compensation)
            -- msgContent = string.format("清除了 %s * %d ， 罚没：$%d", itemType, count, compensation)
            player:setTitle(msgContent, 3)
        else
            -- 如果 itemType 不在 bannedItemsPrice 中，记录错误或执行其他操作
            print("Error: itemType " .. itemType .. " not found in bannedItemsPrice")
        end
    end
end

local function outputLogFile(content)
    file = io.open("plugins/KoharuBan/log.txt", "a")
    file:write(content)
    file:close()
end

local function tableContainsValue(t, value, ext)
    if not ext then
        ext = ""
    end
    for _, v in pairs(t) do
        if ext .. v == value then
            return true
        end
    end
    return false
end

function handlePlayer(player, itemType)
    if itemType == nil then
        return
    end
    if tableContainsValue(mConfig.bannedItems, itemType, "minecraft:") then
        delay = setTimeout(function()
            count = player:clearItem(itemType, 64)
            if count == 0 then
                return
            end
            log(count)
            punish(player, itemType, count)
            outputLogFile(string.format("[%s] %s %s * %d\n", os.date("%Y-%m-%d %H:%M:%S"), player.realName, itemType,
                count))

        end, 200)

        if delay then
            if not mConfig.silenceMode then
                mc.broadcast(string.format(
                    "§l§9[KoharuBan] §c玩家 %s 持有非法物品，多次违规将被踢出游戏！",
                    player.realName))
            end
        else
            outputLogFile(string.format("[ERROR] [%s] %s %s", os.date("%Y-%m-%d %H:%M:%S"), player.realName, itemType))
        end

    end
end

mc.listen("onServerStarted", function()
    colorLog("yellow", "[KoharuBan-Lua] 启动!")
end)

mc.listen("onInventoryChange", function(player, slotNum, oldItem, newItem)

    if mConfig.strictMode then
        if player.uuid ~= mConfig.superOperator then
            handlePlayer(player, newItem.type)
        end
    else
        if not tableContainsValue(mConfig.whitelist, player.uuid) and not player:isOP() then
            handlePlayer(player, newItem.type)
        end
    end

end)
