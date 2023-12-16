local WaitCollect = require(script.Parent.waitCollect)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("children()", function()
        it("should return a table of userdata if the children are found", function()
            local filter = {
                level2 = { Name = "level2" }
            }
            local result = WaitCollect.children(level1, filter)
            expect(result.level2).to.be.equal(level2)
        end)
        it("should error if the children are not found", function()
            local filter = {
                level4 = { Name = "level4" }
            }
            expect(function()
                WaitCollect.children(level1, filter)
            end).to.throw()
        end)
    end)

    describe("descendants()", function()
        it("should return a table of userdata if the descendants are found", function()
            local filter = {
                level3 = { Name = "level3" }
            }
            local result = WaitCollect.descendants(level1, filter)
            expect(result.level3).to.be.equal(level3)
        end)
        it("should error if the descendants are not found", function()
            local filter = {
                level4 = { Name = "level4" }
            }
            expect(function()
                WaitCollect.descendants(level1, filter)
            end).to.throw()
        end)
    end)

    describe("siblings()", function()
        it("should return a table of userdata if the siblings are found", function()
            local filter = {
                other = { Name = "other" }
            }
            local result = WaitCollect.siblings(level2, filter)
            expect(result.other).to.be.equal(otherLevel2)
        end)
        it("should error if the siblings are not found", function()
            local filter = {
                level4 = { Name = "level4" }
            }
            expect(function()
                WaitCollect.siblings(level2, filter)
            end).to.throw()
        end)
    end)

end