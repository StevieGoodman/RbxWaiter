--!strict

--[=[
    @class Option
    An alternative to the Luau optionals, the `Option` class prevents you from forgetting that an optional
    value may be `nil`.
]=]--
local Option = {}

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

Option.__index = Option

--[=[
    @within Option
    @param value T -- Value used to create an `Option` object from
    @return Option -- `Option` object

    Creates an `Option` object from a value.

     ```lua
    local someValue = Option.new(7878) -- Option<Some>
    local noneValue = Option.new(nil)  -- Option<None>
    ```
]=]--
function Option.new(value: any)
    local optionObject = { _value = value }
    local self = setmetatable(optionObject, Option)
    return self
end

--[=[
    @within Option
    @prop None Option<None>
]=]--
Option.none = Option.new()

--[=[
    @within Option
    @param value T -- Non-nil value to wrap as an Option<Some>
    @return Option<Some>

    Creates a `Option` object from a non-`nil` value.  
    Because it throws an error, it's usage is discouraged in favour on `Option.new()`.

    ```lua
    local someValue = Option.some(7878) -- Option<Some>
    local noneValue = Option.some(nil)  -- ERROR: "Provided nil type"
    ```

    @error "Provided nil type" -- Cannot create `Option<Some>` from a `nil` value
]=]--
function Option.some(value: any)
    assert(value ~= nil, "Provided nil type")
    return Option.new(value)
end

--[=[
    @within Option
    @param obj Option -- Option object to check the type of
    @return boolean

    Returns whether or not `obj` is a valid `Option` object
    
    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none()
    local stringValue = "Hello, world!"

    print(Option.is(someValue))   -- true
    print(Option.is(noneValue))   -- true
    print(Option.is(stringValue)) -- false
    ```
]=]--
function Option.is(obj: table): boolean
    return typeof(obj) == "table" and getmetatable(obj) == Option
end

--[=[
    @within Option
    @return boolean

    Returns `true` if the object is of type `Option<None>`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none()

    print(someValue:isNone()) -- false
    print(noneValue:isNone()) -- true
    ```
]=]--
function Option:isNone(): boolean
    return self == Option.none
end

--[=[
    @within Option
    @return boolean

    Returns `true` if calling object is of type `Option<Some>`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none()

    print(someValue:isSome()) -- true
    print(noneValue:isSome()) -- false
    ```
]=]--
function Option:isSome(): boolean
    return not self:isNone()
end

--[=[
    @within Option
    @param cases { Some: (T)->(any), None: ()->(any) }
    @return any

    Executes code according to an exhaustive set of potential `Option` variants.
    Using this in strict mode prevents users from not accounting for a `None` variant.
    You may return a value if you would like.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none

    local cases = {
        Some = function(value) return value end,
        None = function() return "Empty!" end
    }

    print(someValue:match(cases)) -- 7878
    print(noneValue:match(cases)) -- "Empty!"
    ```
]=]--
function Option:match(cases: { some: (any)->(any), none: ()->(any) }): any
    if self:isSome() then
        return cases.some(self:_unwrap())
    elseif self:isNone() then
        return cases.none()
    end
end

--[=[
    @within Option
    @private

    Used internally to unwrap `Option` objects unsafely without raising a warning.  
    Its usage is discouraged.

]=]--
function Option:_unwrap(msg: string?): any
    assert(self:isSome(), msg or ":unwrap() may not be called on Option.none objects")
    return self._value
end


--[=[
    @within Option
    @return any

    Unsafely unwraps the value inside the `Option`.  
    Good for debugging and testing. Do not use in production, instead use `:match()` or `:unwrapOr()`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none

    print(someValue:unwrap()) -- 7878
    print(noneValue:unwrap()) -- ERROR: ":unwrap() may not be called on Option.none objects"
    ```
    @error ":unwrap() may not be called on Option.none objects"
]=]--
function Option:unwrap(msg: string?): any
    warn(":unwrap() should only be used for debugging purposes. For production, instead use :match()")
    return self:_unwrap(msg)
end


--[=[
    @within Option
    @param default any -- Returned if `Option:isNone()`
    @return any

    Safely unwraps the `Option` by returning `default` if `Option:isNone()`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none

    print(someValue:unwrapOr("Oh no!")) -- 7878
    print(noneValue:unwrapOr("...anyway!")) -- "...anyway!"
    ```
]=]--
function Option:unwrapOr(default: any): any
    return self:match {
        some = function(value) return value end,
        none = function() return default end,
    }
end

--[=[
    @within Option
    @param defaultFn any -- Returned if caller `Option:isNone()`
    @return any

    Safely unwraps the `Option` by returning the result of `defaultFn` if `Option:isNone()`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none

    print(someValue:unwrapOrElse(function() return "Oh no!" end)) -- 7878
    print(noneValue:unwrapOrElse(function() return "...anyway!" end)) -- "...anyway!"
    ```
]=]--
function Option:unwrapOrElse(defaultFn: ()->(any)): any
    return self:match {
        some = function(value) return value end,
        none = function() return defaultFn() end
    }
end

--[=[
    @within Option
    @param value any -- Value to check for inside the calling `Option` object
    @return boolean

    Returns if the value inside the calling `Option` object matches `value`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.none()

    print(someValue:contains(7878))     -- true
    print(someValue:contains("Hello"))  -- false
    print(noneValue:contains("World!")) -- false
    ```
]=]--
function Option:contains(value: any): boolean
    return self:isSome() and self:_unwrap() == value
end

--[=[
    @within Option
    @param other any -- Other `Option` object for the calling object to be compared against
    @return Option<Some> | Option<None>

    Returns `other` if the calling option has a value, otherwise returns `Option<None>`.

    ```lua
    local someValueA = Option.new(7878)
    local someValueB = Option.new("I love Rust!")
    local noneValue = Option.none()

    print(someValueA:And(someValueB)) -- Option<Some> (someValueB)
    print(someValueA:And(noneValue))  -- Option<None>
    print(noneValue:And(someValueB))  -- Option<None>
    print(noneValue:And(noneValue))   -- Option<None>
    ```
]=]--
function Option:And(other: any): any
    return if self:isSome() and other:isSome() then other else Option.none
end

--[=[
    @within Option
    @param other any -- Other `Option` object for the calling object to be compared against

    If caller has a value, returns itself. Otherwise, returns `other`.

    ```lua
    local someValueA = Option.new(7878)
    local someValueB = Option.new("I love Rust!")
    local noneValue = Option.none()

    print(someValueA:And(someValueB)) -- Option<Some> (someValueB)
    print(someValueA:And(noneValue))  -- Option<Some> (someValueA)
    print(noneValue:And(someValueB))  -- Option<Some> (someValueB)
    print(noneValue:And(noneValue))   -- Option<None>
    ```
]=]--
function Option:Or(other: any): any
    return if self:isSome() then self else other
end

function Option.__tostring(table)
    return table:match {
        some = function(value)
            return `Option<{typeof(value)}>({value})`
        end,
        none = function()
            return "Option<None>"
        end,
    }
end

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

return Option