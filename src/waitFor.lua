local Option, _ = table.unpack(require(script.Parent.Parent.Custodian))
local Get = require(script.Parent.get)

local waitFor = {}

function waitFor.child(duration, origin, filter)
    local startTime = os.time()
    local child = nil
    repeat
        child = Get.child(origin, filter)
        task.wait()
    until os.time() - startTime > duration or Option.isSome(child)
    return Option.new(child)
end

function waitFor.descendant(duration, origin, filter)
    local startTime = os.time()
    local descendant = nil
    repeat
        descendant = Get.descendant(origin, filter)
        task.wait()
    until os.time() - startTime > duration or Option.isSome(descendant)
    return Option.new(descendant)
end

function waitFor.sibling(duration, origin, filter)
    local startTime = os.time()
    local sibling = nil
    repeat
        sibling = Get.sibling(origin, filter)
        task.wait()
    until os.time() - startTime > duration or Option.isSome(sibling)
    return Option.new(sibling)
end

return waitFor