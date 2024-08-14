local Filter = require(script.Parent.filter)

local get = {}

function get._process(origin: Instance, query: string?, getFunc, searchMode: Filter.SearchMode?)
    local results = getFunc(origin)
    return Filter.process(results, query, searchMode)
end

function get.children(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    return get._process(origin, query, origin.GetChildren, searchMode)
end

function get.child(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    local children = get.children(origin, query, searchMode)
    return children[1]
end

function get.descendants(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    return get._process(origin, query, origin.GetDescendants, searchMode)
end

function get.descendant(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    local descendants = get.descendants(origin, query, searchMode)
    return descendants[1]
end

function get.ancestors(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    local ancestors = {}
    local current = origin
    while current.Parent ~= game do
        current = current.Parent
        table.insert(ancestors, current)
    end
    return Filter.process(ancestors, query, searchMode)
end

function get.ancestor(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    local ancestors = get.ancestors(origin, query, searchMode)
    return ancestors[1]
end

function get.siblings(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    -- Prevents attempting to index game's parent
    if origin == game then
        return {}
    else
        local siblings = get._process(origin.Parent, query, origin.Parent.GetChildren, searchMode)
        -- Removes the origin from the siblings if applicable
        local originIndex = table.find(siblings, origin)
        if originIndex then
            table.remove(siblings, originIndex)
        end
        return siblings
    end
end

function get.sibling(origin: Instance, query: string?, searchMode: Filter.SearchMode?)
    local siblings = get.siblings(origin, query, searchMode)
    return siblings[1]
end

return get