local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.DevPackages.TestEZ)

local Waiter = ReplicatedStorage.Packages.Waiter

TestEZ.TestBootstrap:run({
    Waiter["init.spec"],
})