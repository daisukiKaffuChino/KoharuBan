-- ***这里存放插件的基本配置，包括 物品封禁 相关的配置***
-- 是否启用严格模式。该模式下无视op豁免，仅允许一位op玩家绕过监管，使op滥权难度加大。建议保持此项开启。
strictMode = true

-- 仅在启用严格模式时有效。唯一的realName(真实名称)标识，这不会因为改名而变动。
superOperator = ""

-- 是否启用惩罚
isPunish = true

-- 静默模式，不显示广播。不影响输出日志
silenceMode = false

-- 普通玩家豁免，严格模式下无效。该表值为realName
whitelist = {}

-- 禁止的物品id
bannedItems = {"bedrock", "mob_spawner", "reinforced_deepslate", "structure_block"}

-- 被禁物品的价格
bannedItemsPrice = {
    ["bedrock"] = 24,
    ["mob_spawner"] = 1024,
    ["reinforced_deepslate"] = 128,
    ["structure_block"] = 24
}

-- ***这里存放 玩家封禁 功能相关的配置***
-- 【开发中】非常危险！如果出现问题将造成显著影响
-- 以下所有配置包括封禁命令仅在进阶模式（extendedMode） 和 严格模式（strictMode）开启时生效

-- 是否启用进阶模式。进阶模式下，Koharu真的要踢人了！
extendedMode = true

-- 当被ban玩家登录时保存并输出日志
loginLog = true

-- 断开连接时，客户端的提示文本
-- 封禁时长会自动显示，无需在此配置
banMsg = "[KoharuBan] 因屡次检测到非法行为，你无法连接该服务器。\n若有疑问，请联系管理员。"
