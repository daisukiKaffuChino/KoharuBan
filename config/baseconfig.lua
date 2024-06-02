-- 是否启用严格模式。该模式下无视op豁免，仅允许一位op玩家绕过监管，使op滥权难度加大。建议保持此项开启。
strictMode = true

-- 仅在启用严格模式时有效。唯一的uuid标识。
superOperator = ""

-- 是否启用惩罚
isPunish = true

-- 静默模式，悄悄地测试用。不影响输出日志
silenceMode = false

-- 普通玩家豁免，严格模式下无效。该表值为uuid
whitelist = {}

-- 禁止的物品id
bannedItems = {"bedrock", "mob_spawner", "reinforced_deepslate", "structure_block"}

--被禁物品的价格
bannedItemsPrice = {
    ["bedrock"] = 24,
    ["mob_spawner"] = 1024,
    ["reinforced_deepslate"] = 128,
    ["structure_block"] = 24
}