local Waiter = require(script.Parent)

local function getAmountOfTrackedQueries()
    local count = 0
    for _ in Waiter._trackedQueries do
        count = count + 1
    end
    return count
end

return function()

    local level1_1 = Instance.new("Folder")
    local level1_2 = Instance.new("Folder")
    local level1_3 = Instance.new("Folder")
    local level2_1 = Instance.new("Folder")
    local level2_2 = Instance.new("Folder")
    local level2_3 = Instance.new("Folder")
    local level3_1 = Instance.new("Folder")
    local level3_2 = Instance.new("Folder")
    local level3_3 = Instance.new("Folder")

    level1_1.Parent = game.Workspace
    level1_2.Parent = game.Workspace
    level1_2.Parent = game.Workspace
    level2_1.Parent = level1_1
    level2_2.Parent = level1_1
    level2_3.Parent = level1_1
    level3_1.Parent = level2_1
    level3_2.Parent = level2_1
    level3_3.Parent = level2_1

    level1_1.Name = "Level1_1"
    level1_2.Name = "Level1_2"
    level1_3.Name = "Level1_3"
    level2_1.Name = "Level2_1"
    level2_2.Name = "Level2_2"
    level2_3.Name = "Level2_3"
    level3_1.Name = "Level3_1"
    level3_2.Name = "Level3_2"
    level3_3.Name = "Level3_3"

    local list = {
        level1_1,
        level1_2,
        level1_3,
        level2_1,
        level2_2,
        level2_3,
        level3_1,
        level3_2,
        level3_3,
    }

    afterEach(function()
        for _, instance: Instance in list do
            for _, tag in instance:GetTags() do
                instance:RemoveTag(tag)
            end
        end
    end)

    describe("Waiter.descendants()", function()

        local descendants = Waiter.descendants(level1_1)

        it("should return a list of descendants", function()
            expect(#descendants).to.be.equal(6)
            expect(descendants[1]).to.be.equal(level2_1)
            expect(descendants[2]).to.be.equal(level3_1)
            expect(descendants[3]).to.be.equal(level3_2)
            expect(descendants[4]).to.be.equal(level3_3)
            expect(descendants[5]).to.be.equal(level2_2)
            expect(descendants[6]).to.be.equal(level2_3)
        end)

        it("should not include the instance passed into the function", function()
            expect(table.find(descendants, level1_1)).to.be.equal(nil)
        end)

        it("should update when descendants are added and removed", function()
            local level4_1 = Instance.new("Folder")
            level4_1.Parent = level3_1
            level4_1.Name = "Level4_1"
            task.wait()
            expect(#descendants).to.be.equal(7)
            expect(descendants[7]).to.be.equal(level4_1)
            level4_1:Destroy()
            task.wait()
            expect(#descendants).to.be.equal(6)
            expect(table.find(descendants, level4_1)).to.be.equal(nil)
        end)

        it("should garbage collect the descendants table when there is no strong reference to it", function()
            local amountOfTrackedQueries = getAmountOfTrackedQueries()
            expect(amountOfTrackedQueries > 0).to.be.equal(true)
            task.wait(1)
            descendants = nil
            local memoryPressure = {}
            while #memoryPressure < 50_000 do
                for _ = 1, 500 do
                    table.insert(memoryPressure, Instance.new("Part"))
                end
                local percentage = math.round((#memoryPressure / 50_000) * 100)
                print(`Memory pressure applied: {percentage}%`)
                task.wait()
            end
            for _, instance: Instance in memoryPressure do
                instance:Destroy()
            end
            expect(getAmountOfTrackedQueries()).to.be.equal(amountOfTrackedQueries - 1)
        end)

    end)

    describe("Waiter.children()", function()

        local children = Waiter.children(level1_1)

        it("should return a list of children", function()
            expect(#children).to.be.equal(3)
            expect(children[1]).to.be.equal(level2_1)
            expect(children[2]).to.be.equal(level2_2)
            expect(children[3]).to.be.equal(level2_3)
        end)

        it("should not include the instance passed into the function", function()
            expect(table.find(children, level1_1)).to.be.equal(nil)
        end)

        it("should not include descendants", function()
            expect(table.find(children, level3_1)).to.be.equal(nil)
            expect(table.find(children, level3_2)).to.be.equal(nil)
            expect(table.find(children, level3_3)).to.be.equal(nil)
        end)

        it("should update when children are added and removed", function()
            local level2_4 = Instance.new("Folder")
            level2_4.Parent = level1_1
            level2_4.Name = "Level2_4"
            task.wait()
            expect(#children).to.be.equal(4)
            expect(children[4]).to.be.equal(level2_4)
            level2_4:Destroy()
            task.wait()
            expect(#children).to.be.equal(3)
            expect(table.find(children, level2_4)).to.be.equal(nil)
        end)

        it("should garbage collect the children table when there is no strong reference to it", function()
            local amountOfTrackedQueries = getAmountOfTrackedQueries()
            expect(amountOfTrackedQueries > 0).to.be.equal(true)
            task.wait(1)
            children = nil
            local memoryPressure = {}
            while #memoryPressure < 50_000 do
                for _ = 1, 500 do
                    table.insert(memoryPressure, Instance.new("Part"))
                end
                local percentage = math.round((#memoryPressure / 50_000) * 100)
                print(`Memory pressure applied: {percentage}%`)
                task.wait()
            end
            for _, instance: Instance in memoryPressure do
                instance:Destroy()
            end
            expect(getAmountOfTrackedQueries()).to.be.equal(amountOfTrackedQueries - 1)
        end)

    end)

    describe("Waiter.ancestors()", function()

        local ancestors = Waiter.ancestors(level3_1)

        it("should return a list of ancestors", function()
            expect(#ancestors).to.be.equal(4)
            expect(ancestors[1]).to.be.equal(level2_1)
            expect(ancestors[2]).to.be.equal(level1_1)
            expect(ancestors[3]).to.be.equal(game.Workspace)
            expect(ancestors[4]).to.be.equal(game)
        end)

        it("should not include the instance passed into the function", function()
            expect(table.find(ancestors, level3_1)).to.be.equal(nil)
        end)

        it("should include top-level services", function()
            expect(table.find(ancestors, game.Workspace)).to.be.equal(3)
        end)

        it("should include the datamodel", function()
            expect(table.find(ancestors, game)).to.be.equal(4)
        end)

        it("should not error when the datamodel is passed into the function", function()
            expect(function()
                Waiter.ancestors(game)
            end).never.to.throw()
        end)

        it("should update when ancestors are added and removed", function()
            local level0_1 = Instance.new("Folder")
            level0_1.Parent = game.Workspace
            level0_1.Name = "Level0_1"
            level3_1.Parent = level0_1
            task.wait()
            expect(#ancestors).to.be.equal(3)
            expect(ancestors[1]).to.be.equal(level0_1)
            level3_1.Parent = level2_1
            level0_1:Destroy()
            task.wait()
            expect(#ancestors).to.be.equal(4)
            expect(table.find(ancestors, level0_1)).to.be.equal(nil)
        end)

        it("should garbage collect the siblings table when there is no strong reference to it", function()
            local amountOfTrackedQueries = getAmountOfTrackedQueries()
            expect(amountOfTrackedQueries > 0).to.be.equal(true)
            task.wait(1)
            ancestors = nil
            local memoryPressure = {}
            while #memoryPressure < 50_000 do
                for _ = 1, 500 do
                    table.insert(memoryPressure, Instance.new("Part"))
                end
                local percentage = math.round((#memoryPressure / 50_000) * 100)
                print(`Memory pressure applied: {percentage}%`)
                task.wait()
            end
            for _, instance: Instance in memoryPressure do
                instance:Destroy()
            end
            expect(getAmountOfTrackedQueries()).to.be.equal(amountOfTrackedQueries - 2)
        end)

    end)

    describe("Waiter.siblings()", function()

        local siblings = Waiter.siblings(level2_2)

        it("should return a list of siblings", function()
            expect(#siblings).to.be.equal(2)
            expect(siblings[1]).to.be.equal(level2_1)
            expect(siblings[2]).to.be.equal(level2_3)
        end)

        it("should not include the instance passed into the function", function()
            expect(table.find(siblings, level2_2)).to.be.equal(nil)
        end)

        it("should garbage collect the siblings table when there is no strong reference to it", function()
            local amountOfTrackedQueries = getAmountOfTrackedQueries()
            expect(amountOfTrackedQueries > 0).to.be.equal(true)

            task.wait(1)
            siblings = nil
            local memoryPressure = {}
            while #memoryPressure < 50_000 do
                for _ = 1, 500 do
                    table.insert(memoryPressure, Instance.new("Part"))
                end
                local percentage = math.round((#memoryPressure / 50_000) * 100)
                print(`Memory pressure applied: {percentage}%`)
                task.wait()
            end
            for _, instance: Instance in memoryPressure do
                instance:Destroy()
            end
            expect(getAmountOfTrackedQueries()).to.be.equal(amountOfTrackedQueries - 1)
        end)

    end)

    describe("Waiter._trackedQueries", function()
        it("should have cleaned up all tracked queries", function()
            expect(getAmountOfTrackedQueries()).to.be.equal(0)
        end)
    end)

    describe("Waiter.get()", function()

        local results = Waiter.get(list, function(instance: Instance): boolean
            return instance.Name == "Level1_1" or instance.Name == "Level2_1"
        end)

        it("should return a list of instances that match the predicate", function()
            expect(#results).to.be.equal(2)
            expect(results[1]).to.be.equal(level1_1)
            expect(results[2]).to.be.equal(level2_1)
        end)

    end)

    describe("Waiter.getFirst()", function()

        local result = Waiter.getFirst(list, function(instance: Instance): boolean
            return instance.Name == "Level1_1" or instance.Name == "Level2_1"
        end)

        it("should return the first instance that matches the predicate", function()
            expect(result).to.be.equal(level1_1)
        end)

    end)

    describe("Waiter.waitFor()", function()

        it("should resolve when an instance matches the predicate", function()
            local promise = Waiter.waitFor(list, Waiter.matchName("Level1_1"))
            local success, result = promise:await()
            expect(success).to.be.equal(true)
            expect(result).to.be.equal(level1_1)
        end)

        it("should resolve when an instance is added to the list", function()
            local promise = Waiter.waitFor(Waiter.descendants(level1_1), Waiter.matchName("Level3_4"), 2)
            task.wait(1)
            expect(promise:getStatus()).to.be.equal("Started")
            local level3_4 = Instance.new("Folder")
            level3_4.Parent = level2_1
            level3_4.Name = "Level3_4"
            local success, result = promise:await()
            expect(success).to.be.equal(true)
            expect(result).to.be.equal(level3_4)
        end)

        it("should reject when the timeout is reached", function()
            local promise = Waiter.waitFor(
                list,
                function(_: Instance): boolean
                    return false
                end,
                0.1)
            local status = promise:awaitStatus()
            expect(status).to.be.equal("Rejected")
        end)

    end)

    describe("Waiter.matchTag()", function()

        level1_1:AddTag("Tag1")
        level1_2:AddTag("Tag2")
        level1_3:AddTag("Tag3")
        level2_1:AddTag("Tag1")
        level2_2:AddTag("Tag2")
        level2_3:AddTag("Tag3")
        level3_1:AddTag("Tag1")
        level3_2:AddTag("Tag2")
        level3_3:AddTag("Tag3")

        local results = Waiter.get(list, Waiter.matchTag("Tag1"))

        it("should return a list of instances that match the tag", function()
            expect(#results).to.be.equal(3)
            expect(results[1]).to.be.equal(level1_1)
            expect(results[2]).to.be.equal(level2_1)
            expect(results[3]).to.be.equal(level3_1)
        end)

    end)

    describe("Waiter.matchAttribute()", function()
        level1_1:SetAttribute("Level", 1)
        level1_2:SetAttribute("Level", 1)
        level1_3:SetAttribute("Level", 1)
        level2_1:SetAttribute("Level", 2)
        level2_2:SetAttribute("Level", 2)
        level2_3:SetAttribute("Level", 2)
        level3_1:SetAttribute("Level", 3)
        level3_2:SetAttribute("Level", 3)
        level3_3:SetAttribute("Level", 3)

        local results = Waiter.get(list, Waiter.matchAttribute("Level", 2))

        it("should return a list of instances that match the attribute", function()
            expect(#results).to.be.equal(3)
            expect(results[1]).to.be.equal(level2_1)
            expect(results[2]).to.be.equal(level2_2)
            expect(results[3]).to.be.equal(level2_3)
        end)
    end)

    describe("Waiter.matchClassName()", function()

        it("should return a list of instances that match the class name", function()
            local results = Waiter.get(list, Waiter.matchClassName("Folder"))
            expect(#results).to.be.equal(9)
            expect(results[1]).to.be.equal(level1_1)
            expect(results[2]).to.be.equal(level1_2)
            expect(results[3]).to.be.equal(level1_3)
            expect(results[4]).to.be.equal(level2_1)
            expect(results[5]).to.be.equal(level2_2)
            expect(results[6]).to.be.equal(level2_3)
            expect(results[7]).to.be.equal(level3_1)
            expect(results[8]).to.be.equal(level3_2)
            expect(results[9]).to.be.equal(level3_3)
        end)

        it("should not include instances that do not match the class name", function()
            local results = Waiter.get(list, Waiter.matchClassName("Model"))
            expect(#results).to.be.equal(0)
        end)

    end)

    describe("Waiter.matchName()", function()

        it("should return a list of instances that match the name", function()
            local results = Waiter.get(list, Waiter.matchName("Level1_1"))
            expect(#results).to.be.equal(1)
            expect(results[1]).to.be.equal(level1_1)
        end)

        it("should not include instances that do not match the name", function()
            local results = Waiter.get(list, Waiter.matchName("Level1_4"))
            expect(#results).to.be.equal(0)
        end)

    end)
end