local Collect = require(script.Parent.collect)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("children()", function()
        it("should return the correct types depending on result for each tag", function()
            local tags = {
                level1 = "level1",
                level2 = "level2",
                level4 = "level4",
            }
            local table = Collect.children(workspace, tags)
            expect(table.level1).to.be.equal(level1)
            expect(#table.level2).to.be.equal(0)
            expect(#table.level4).to.be.equal(0)
            table = Collect.children(level1, tags)
            expect(#table.level1).to.be.equal(0)
            expect(#table.level2).to.be.equal(2)
            expect(#table.level4).to.be.equal(0)
        end)
    end)

    describe("descendants()", function()
        it("should return the correct types depending on result for each tag", function()
            local filters = {
                level2 = "level2",
                child = "child",
                level3 = "level3",
                level4 = "level4",
            }
            local table = Collect.descendants(level1, filters)
            expect(#table.level2).to.be.equal(2)
            expect(#table.child).to.be.equal(3)
            expect(table.level3).to.be.equal(level3)
            expect(#table.level4).to.be.equal(0)
        end)
    end)

    describe("ancestors()", function()
        it("should return the correct types depending on result for each tag", function()
            local filters = {
                level1 = "level1",
                level2 = "level2",
                level3 = "level3",
                level4 = "level4",
            }
            local table = Collect.ancestors(level3, filters)
            expect(table.level1).to.be.equal(level1)
            expect(table.level2).to.be.equal(level2)
            expect(#table.level3).to.be.equal(0)
            expect(#table.level4).to.be.equal(0)
        end)
    end)

    describe("siblings()", function()
        it("should return the correct types depending on result for each tag", function()
            local filters = {
                other = "other",
                level2 = "level2",
                level3 = "level3",
            }
            local table = Collect.siblings(level2, filters)
            expect(table.other).to.be.equal(otherLevel2)
            expect(table.level2).to.be.equal(otherLevel2)
            expect(#table.level3).to.be.equal(0)
        end)
    end)

end