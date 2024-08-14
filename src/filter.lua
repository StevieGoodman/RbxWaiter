local TableUtil = require(script.Parent.Parent.TableUtil)

export type SearchMode = "Tag" | "ClassName"
type SearchModeFilterFunction = (Instance, string) -> boolean

local SEARCH_MODE_FUNCTIONS = {
    Tag = function(instance, tagQuery)
        return instance:HasTag(tagQuery)
    end,
    ClassName = function(instance, classNameQuery)
        return instance:IsA(classNameQuery)
    end
} :: { SearchModeFilterFunction }

local filter = {}

function filter.process(instances, query: string?, searchMode: SearchMode?)
    searchMode = searchMode or "Tag"
    if not query then
        return instances
    else
        return TableUtil.Filter(instances, function(instance)
            return SEARCH_MODE_FUNCTIONS[searchMode](instance, query)
        end)
    end
end

return filter