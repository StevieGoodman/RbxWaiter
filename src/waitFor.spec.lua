local WaitFor = require(script.Parent.waitFor)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("child()", function()
        it("should return a userdata if the child is found", function()
            local filter = {Name = "level2"}
            local result = WaitFor.child(level1, filter)
            expect(result).to.be.equal(level2)
        end)
        it("should return nil if the child is not found", function()
            local filter = {Name = "level4"}
            local result = WaitFor.child(level1, filter)
            expect(result).to.be.equal(nil)
        end)
    end)

    describe("descendant()", function()
        it("should return a userdata if the descendant is found", function()
            local filter = {Name = "level3"}
            local result = WaitFor.descendant(level1, filter)
            expect(result).to.be.equal(level3)
        end)
        it("should return nil if the descendant is not found", function()
            local filter = {Name = "level4"}
            local result = WaitFor.descendant(level1, filter)
            expect(result).to.be.equal(nil)
        end)
    end)

    describe("sibling()", function()
        it("should return a userdata if the sibling is found", function()
            local filter = {Name = "other"}
            local result = WaitFor.sibling(level2, filter)
            expect(result).to.be.equal(otherLevel2)
        end)
        it("should return nil if the sibling is not found", function()
            local filter = {Name = "level4"}
            local result = WaitFor.sibling(level2, filter)
            expect(result).to.be.equal(nil)
        end)
    end)
end