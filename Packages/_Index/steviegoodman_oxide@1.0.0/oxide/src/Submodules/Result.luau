--!strict

--[=[
    @class Result
    An alternative to Luau error handling, the `Result` class requires you to consider potential errors
    before accessing the wrapped value.
]=]--
local Result = {}

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

local Option = require(script.Parent.Option)

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

Result.__index = Result

function Result.ok(value)
    if value then
        local self = { _value = value }
        self = setmetatable(self, Result)
        return Option.new(self)
    else
        return Option.none
    end
end

function Result.err(err)
    if err then
        local self = { _err = err }
        self = setmetatable(self, Result)
        return Option.new(self)
    else
        return Option.none
    end
end

function Result.is(obj)
    return typeof(obj) == "table" and getmetatable(obj) == Result
end

function Result:isOk()
    return self._value ~= nil
end

function Result:isErr()
    return not self:isOk()
end

function Result:match(cases)
    if self:isOk() then
        return cases.ok(self._value)
    elseif self:isErr() then
        return cases.err(self._err)
    end
end

function Result:unwrap()
    warn(":unwrap() should only be used for debugging purposes. For production, instead use :match()")
    assert(self:isOk(), "Cannot unwrap Result<Err>")
    return self._value
end

function Result:unwrapErr()
    warn(":unwrapErr() should only be used for debugging purposes. For production, instead use :match()")
    assert(self:isErr(), "Cannot unwrap Result<Ok>")
    return self._err
end

function Result:unwrapOr(default)
    return self:match {
        ok = function(value) return value end,
        err = function(_) return default end,
    }
end

function Result:unwrapOrElse(defaultFn)
    return self:match {
        ok = function(value) return value end,
        err = function(err) return defaultFn(err) end
    }
end

function Result:contains(value)
    return self:isOk() and self._value == value
end

function Result:containsErr(err)
    return self:isErr() and self._err == err
end

function Result:And(other)
    return if self:isOk() and other:isOk() then other else if self:isErr() then self else other
end


function Result:Or(other)
    --[[
        if self = Ok and other = Ok then return self or other
        if self = Ok and other = Err then return other
        if self = Err and other = Ok then return self
        if self = Err and other = Err then return self or other
    ]]--
    return if self:isOk() then other else self
end

function Result.__tostring(table)
    return table:match {
        ok = function(value)
            return `Result<Ok, {typeof(value)}>({value})`
        end,
        err = function(err)
            return `Result<Err, {typeof(err)}>({err})`
        end,
    }
end

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

return Result