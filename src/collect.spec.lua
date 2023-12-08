local Custodian = require(script.Parent.Parent.Custodian)
local Collect = require(script.Parent.collect)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("children()", function()
        it("should return a custodian.result.error if any child is not found", function()
            local filters = {
                {Name = "level2"},
                {Name = "level3"},
            }
            local result = Collect.children(level1, filters)
            expect(Custodian.result.isErr(result)).to.be.equal(true)
        end)

        it("should return a list of children that match a filter", function()
            local filters = {
                {Name = "level2"},
            }
            local result = Collect.children(level1, filters)
            local pass = false
            Custodian.result.isOkThen(result, function(list)
                expect(list[1]).to.be.equal(level2)
                pass = true
            end)
            expect(pass).to.be.equal(true)
        end)
    end)

    describe("descendants()", function()
        it("should return a custodian.result.err if any descendant is not found", function()
            local filters = {
                {Name = "level2"},
                {Name = "level4"},
            }
            local result = Collect.descendants(level1, filters)
            expect(Custodian.result.isErr(result)).to.be.equal(true)
        end)

        it("should return a list of descendants that match a filter", function()
            local filters = {
                {Name = "level2"},
                {Name = "other"},
                {Name = "level3"},
            }
            local result = Collect.descendants(level1, filters)
            local pass = false
            Custodian.result.isOkThen(result, function(list)
                expect(list[1]).to.be.equal(level2)
                expect(list[2]).to.be.equal(otherLevel2)
                expect(list[3]).to.be.equal(level3)
                pass = true
            end)
            expect(pass).to.be.equal(true)
        end)
    end)

    describe("ancestors()", function()
        it("should return a custodian.result.err if any ancestor is not found", function()
            local filters = {
                {Name = "level1"},
                {Name = "level4"},
            }
            local result = Collect.ancestors(level3, filters)
            expect(Custodian.result.isErr(result)).to.be.equal(true)
        end)

        it("should return a list of ancestors that match a filter", function()
            local filters = {
                {Name = "level1"},
                {Name = "level2"},
            }
            local result = Collect.ancestors(level3, filters)
            local pass = false
            Custodian.result.isOkThen(result, function(list)
                expect(list[1]).to.be.equal(level1)
                expect(list[2]).to.be.equal(level2)
                pass = true
            end)
            expect(pass).to.be.equal(true)
        end)
    end)

    describe("siblings()", function()
        it("should return a custodian.result.err if any sibling is not found", function()
            local filters = {
                {Name = "level2"},
                {Name = "level4"},
            }
            local result = Collect.siblings(level3, filters)
            expect(Custodian.result.isErr(result)).to.be.equal(true)
        end)

        it("should return a list of siblings that match a filter", function()
            local filters = {
                {Name = "other"},
            }
            local result = Collect.siblings(level2, filters)
            local pass = false
            Custodian.result.isOkThen(result, function(list)
                expect(list[1]).to.be.equal(otherLevel2)
                pass = true
            end)
            expect(pass).to.be.equal(true)
        end)
    end)

end