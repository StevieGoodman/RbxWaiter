local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Waiter = require(ReplicatedStorage.Packages.Waiter)

assert(Waiter.GetChild(script.Parent) == script)
assert(Waiter.GetChild(script.Parent, { Name = "Tests" }) == script)
assert(Waiter.GetChild(script.Parent, { Name = "Hi" }) == nil)