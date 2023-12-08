local Custodian = require(script.Parent.Parent.Custodian)
local WaitFor = require(script.Parent.waitFor)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("child()", function()
        it("should return a custodian.option.some if child is found", function()
            local optionObj = WaitFor.child(1, level1, {Name = "level2"})
            expect(Custodian.option.isSome(optionObj)).to.equal(true)
            expect(optionObj.value).to.equal(level2)
        end)

        it("should return a custodian.option.none if child is not found", function()
            local optionObj = WaitFor.child(1, level1, {Name = "level3"})
            expect(Custodian.option.isNone(optionObj)).to.equal(true)
        end)
    end)

    describe("descendant()", function()
        it("should return a custodian.option.some if descendant is found", function()
            local optionObj = WaitFor.descendant(1, level1, {Name = "level3"})
            expect(Custodian.option.isSome(optionObj)).to.equal(true)
            expect(optionObj.value).to.equal(level3)
        end)

        it("should return a custodian.option.none if descendant is not found", function()
            local optionObj = WaitFor.descendant(1, level1, {Name = "level4"})
            expect(Custodian.option.isNone(optionObj)).to.equal(true)
        end)
    end)

    describe("sibling()", function()
        it("should return a custodian.option.some if sibling is found", function()
            local optionObj = WaitFor.sibling(1, level2, {Name = "other"})
            expect(Custodian.option.isSome(optionObj)).to.equal(true)
            expect(optionObj.value).to.equal(otherLevel2)
        end)

        it("should return a custodian.option.none if sibling is not found", function()
            local optionObj = WaitFor.sibling(1, level2, {Name = "level3"})
            expect(Custodian.option.isNone(optionObj)).to.equal(true)
        end)
    end)
end