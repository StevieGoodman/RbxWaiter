local Option, _ = table.unpack(require(script.Parent.Parent.Custodian))
local Filter = require(script.Parent.filter)

local get = {}

function get.children(origin, filter)
    local children = origin:GetChildren()
    children = Filter.process(children, filter)
    if #children == 0 then
        return Option.none()
    else
        return Option.new(children)
    end
    return children
end

function get.child(origin, filter)
    local optionObj = get.children(origin, filter)
    Option.isSomeThen(optionObj, function(children)
        return children[1]
    end)
    return Option.none()
end

function get.descendants(origin, filter)
    local descendants = origin:GetDescendants()
    descendants = Filter.process(descendants, filter)
    if #descendants == 0 then
        return Option.none()
    else
        return Option.new(descendants)
    end
    return descendants
end

function get.descendant(origin, filter)
    local optionObj = get.descendants(origin, filter)
    Option.isSomeThen(optionObj, function(descendants)
        return descendants[1]
    end)
    return Option.none()
end

function get.ancestors(origin, filter)
    local ancestors = {}
    local current = origin
    repeat
        current = current.Parent
        table.insert(ancestors, current)
    until current.Parent == game
    ancestors = Filter.process(ancestors, filter)
    if #ancestors == 0 then
        return Option.none()
    else
        return Option.new(ancestors)
    end
    return ancestors
end

function get.ancestor(origin, filter)
    local optionObj = get.ancestors(origin, filter)
    Option.isSomeThen(optionObj, function(ancestors)
        return ancestors[1]
    end)
    return Option.none()
end

function get.siblings(origin, filter)
    local siblings = get.children(origin.Parent, filter)
    if #siblings == 0 then
        return Option.none()
    else
        return Option.new(siblings)
    end
end

function get.sibling(origin, filter)
    local optionObj = get.siblings(origin, filter)
    Option.isSomeThen(optionObj, function(siblings)
        return siblings[1]
    end)
    return Option.none()
end

return get