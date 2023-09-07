--[=[
    @class Waiter
    Obtain instances in your game hierarchy with zero fuss!
]=]--

local REPL_STORE = game:GetService("ReplicatedStorage")

--[=[
    @within Waiter
    Returns the first child of `origin` matching `targetName` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetChild(origin: Instance, targetName: string, targetTag: string?): Instance?
    local result = origin:FindFirstChild(targetName)
    if result and targetTag then
        result = if result:HasTag(targetTag) then result else nil
    end
    return result
end

--[=[
    @within Waiter
    Returns the first children of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function GetChildren(origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = GetChild(origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first descendants of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetDescendant(origin: Instance, targetName: string, targetTag: string?): Instance?
    local result = origin:FindFirstChild(targetName, true)
    if result and targetTag then
        result = if result:HasTag(targetTag) then result else nil
    end
    return result
end

--[=[
    @within Waiter
    Returns the first descendants of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function GetDescendants(origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = GetDescendant(origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first ancestor of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetAncestor(origin: Instance, targetName: string, targetTag: string?): Instance?
    local result = origin:FindFirstAncestor(targetName)
    if result and targetTag then
        result = if result:HasTag(targetTag) then result else nil
    end
    return result
end

--[=[
    @within Waiter
    Returns the first ancestors of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function GetAncestors(origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = GetAncestor(origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first sibling of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetSibling(origin: Instance, targetName: string, targetTag: string?): Instance?
    local result = GetChild(origin.Parent, targetName, targetTag)
    if result and targetTag then
        result = if result:HasTag(targetTag) then result else nil
    end
    return result
end

--[=[
    @within Waiter
    Returns the first siblings of `origin` matching `targetNames` and `targetTag`.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function GetSiblings(origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = GetSibling(origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first child of `origin` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForChild(duration: number, origin: Instance, targetName: string, targetTag: string?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetChild(origin, targetName, targetTag)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    return result
end

--[=[
    @within Waiter
    Returns the first children of `origin` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function WaitForChildren(duration: number, origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = WaitForChild(duration, origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first descendant of `origin` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForDescendant(duration: number, origin: Instance, targetName: string, targetTag: string?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetDescendant(origin, targetName, targetTag)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    
    return result
end

--[=[
    @within Waiter
    Returns the first descendants of `origin` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function WaitForDescendants(duration: number, origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = WaitForDescendant(duration, origin, targetName, targetTag)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first child of `sibling` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetName string -- The name of the instance being searched for.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForSibling(duration: number, origin: Instance, targetName: string, targetTag: string?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetSibling(origin, targetName, targetTag)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    return result
end

--[=[
    @within Waiter
    Returns the first siblings of `origin` matching `targetNames` and `targetTag` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param targetNames {string: string} -- Dictionary of names to search for. The indices provided will be present in the returned table.
    @param targetTag string? -- If present, only instances with this tag will be considered.
    @return {string: Instance?} -- The instances found (if any).
]=]--
function WaitForSiblings(duration: number, origin: Instance, targetNames: {string: string}, targetTag: string?): {string: Instance?}
    local result = {}
    for index, targetName in targetNames do
        result[index] = WaitForSibling(duration, origin, targetName, targetTag)
    end
    return result
end

local module = {
    GetChild           = GetChild,
    GetChildren        = GetChildren,
    GetDescendant      = GetDescendant,
    GetDescendants     = GetDescendants,
    GetAncestor        = GetAncestor,
    GetAncestors       = GetAncestors,
    GetSibling         = GetSibling,
    GetSiblings        = GetSiblings,
    WaitForChild       = WaitForChild,
    WaitForChildren    = WaitForChildren,
    WaitForDescendant  = WaitForDescendant,
    WaitForDescendants = WaitForDescendants,
    WaitForSibling     = WaitForSibling,
    WaitForSiblings    = WaitForSiblings,
}

return module