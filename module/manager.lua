local mod = {}
setmetatable(mod, mod)

function mod.loadConfig(file)
    local _config = {}
    loadfile(string.format("plugins/KoharuBan/config/%s.lua", file), "bt", _config)()
    return _config
end

function mod.fileToTable(f)
    local file, err = io.open(scriptDir .. f, "r")
    if file then
        local str = file:read("*a")
        file:close()
        return load("return " .. str)()
    else
        logger.error("无法打开文件: " .. err)
        return {}
    end
end

function mod.tableToFile(f, t)
    local file, err = io.open(scriptDir .. f, "w")
    if not file then
        logger.error("打开文件时出错：" .. err)
        return
    end
    file:write(mod.dump(t))
    file:close()
end

-- 删除表中符合conditionFunc的数据
function mod.removeTableData(tb, conditionFunc)
    if tb ~= nil and next(tb) ~= nil then
        -- todo
        for i = #tb, 1, -1 do
            if conditionFunc(tb[i]) then
                table.remove(tb, i)
                return true
            end
        end
    end
end

function mod.dump(o)
    local t = {}
    local _t = {}
    local _n = {}
    local space, deep = string.rep(' ', 2), 0
    local function _ToString(o, _k)
        if type(o) == ('number') then
            table.insert(t, o)
        elseif type(o) == ('string') then
            table.insert(t, string.format('%q', o))
        elseif type(o) == ('table') then
            local mt = getmetatable(o)
            if mt and mt.__tostring then
                table.insert(t, tostring(o))
            else
                deep = deep + 2
                table.insert(t, '{')

                for k, v in pairs(o) do
                    if v == _G then
                        table.insert(t, string.format('\r\n%s%s\t=%s ;', string.rep(space, deep - 1), k, "_G"))
                    elseif v ~= package.loaded then
                        if tonumber(k) then
                            k = string.format('[%s]', k)
                        else
                            k = string.format('[\"%s\"]', k)
                        end
                        table.insert(t, string.format('\r\n%s%s\t= ', string.rep(space, deep - 1), k))
                        if v == NIL then
                            table.insert(t, string.format('%s ;', "nil"))
                        elseif type(v) == ('table') then
                            if _t[tostring(v)] == nil then
                                _t[tostring(v)] = v
                                local _k = _k .. k
                                _t[tostring(v)] = _k
                                _ToString(v, _k)
                            else
                                table.insert(t, tostring(_t[tostring(v)]))
                                table.insert(t, ';')
                            end
                        else
                            _ToString(v, _k)
                        end
                    end
                end
                table.insert(t, string.format('\r\n%s}', string.rep(space, deep - 1)))
                deep = deep - 2
            end
        else
            table.insert(t, tostring(o))
        end
        table.insert(t, " ;")
        return t
    end

    t = _ToString(o, '')
    return table.concat(t)
end

-- debug 用字符串输出表
function mod.logTable(t, level)
    if level then
        logger.setConsole(true, level)
    else
        logger.setConsole(true, 4)
    end
    logger.info(mod.dump(t))
end

local function clone(tb)
    copy = {}
    for k, v in pairs(tb) do
        copy[k] = v
    end
    return copy
end

-- 使用元表方法返回自身实例
function mod.__call(self)
    self = clone(self)
    return self
end

return mod
