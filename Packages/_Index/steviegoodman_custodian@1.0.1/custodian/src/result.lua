local result = {}

function result.ok(val)
    return { ok = val }
end

function result.err(val)
    return { err = val }
end

function result.isOk(resultObj)
    return resultObj.ok ~= nil
end

function result.isErr(resultObj)
    return resultObj.err ~= nil
end

function result.isOkThen(resultObj, callback, ...)
    if result.isOk(resultObj) then
        return callback(resultObj.ok, ...)
    end
end

function result.isErrThen(resultObj, callback, ...)
    if result.isErr(resultObj) then
        return callback(resultObj.err, ...)
    end
end

function result.isOkThenCall(resultObj, callback, ...)
    if result.isOk(resultObj) then
        return callback(...)
    end
end

function result.isErrThenCall(resultObj, callback, ...)
    if result.isErr(resultObj) then
        return callback(...)
    end
end

function result.switch(resultObj, switchTable)
    if result.isOk(resultObj) then
        return switchTable.ok
    else
        return switchTable.err
    end
end

function result.switchThen(resultObj, switchTable, ...)
    result.isOkThen(resultObj, switchTable.ok, ...)
    result.isErrThen(resultObj, switchTable.err, ...)
end

function result.switchThenCall(resultObj, switchTable, ...)
    result.isOkThenCall(resultObj, switchTable.ok, ...)
    result.isErrThenCall(resultObj, switchTable.err, ...)
end

function result.expectOk(resultObj)
    if result.isErr(resultObj) then
        error("Called custodian.result.expectOk() on custodian.result.err!")
    end
end

function result.expectErr(resultObj)
    if result.isErr(resultObj) then
        error("Called custodian.option.expectErr() on custodian.result.ok!")
    end
end

function result.expectOkThen(resultObj, callback, ...)
    result.expectOk(resultObj)
    return callback(resultObj.value, ...)
end

function result.expectErrThen(resultObj, callback, ...)
    result.expectErr(resultObj)
    return callback(resultObj.value, ...)
end

return result