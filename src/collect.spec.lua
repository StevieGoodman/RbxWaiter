local Collect = require(script.Parent.collect)

return function()
    local level1 = game.Workspace.level1
    local level2 = level1.level2
    local otherLevel2 = level1.other
    local level3 = level2.level3

    describe("children()", function()
        it("should return a userdata if the children are found", function()
            local filters = {
                level2 = {Name = "level2"},
                other = {Name = "other"},
            }
            local table = Collect.children(level1, filters)
            expect(table.level2).to.be.equal(level2)
            expect(table.other).to.be.equal(otherLevel2)
        end)
        it("should error if any child is not found", function()
            local filters = {
                level2 = {Name = "level2"},
                other = {Name = "other"},
                level3 = {Name = "level3"},
            }
            expect(function()
                Collect.children(level1, filters)
            end).to.throw()
        end)
    end)

    describe("descendants()", function()
        it("should return a userdata if the descendants are found", function()
            local filters = {
                level2 = {Name = "level2"},
                other = {Name = "other"},
                level3 = {Name = "level3"},
            }
            local table = Collect.descendants(level1, filters)
            expect(table.level2).to.be.equal(level2)
            expect(table.other).to.be.equal(otherLevel2)
            expect(table.level3).to.be.equal(level3)
        end)
        it("should error if any descendant is not found", function()
            local filters = {
                level2 = {Name = "level2"},
                other = {Name = "other"},
                level4 = {Name = "level4"},
            }
            expect(function()
                Collect.descendants(level1, filters)
            end).to.throw()
        end)
    end)

    describe("ancestors()", function()
        it("should return a userdata if the ancestors are found", function()
            local filters = {
                level1 = {Name = "level1"},
                workspace = {Name = "Workspace"},
            }
            local table = Collect.ancestors(level3, filters)
            expect(table.level1).to.be.equal(level1)
            expect(table.workspace).to.be.equal(game.Workspace)
        end)
        it("should error if any ancestor is not found", function()
            local filters = {
                level1 = {Name = "level1"},
                workspace = {Name = "Workspace"},
                game = {Name = "game"},
            }
            expect(function()
                Collect.ancestors(level3, filters)
            end).to.throw()
        end)
    end)

    describe("siblings()", function()
        it("should return a userdata if the siblings are found", function()
            local filters = {
                other = {Name = "other"},
            }
            local table = Collect.siblings(level2, filters)
            expect(table.other).to.be.equal(otherLevel2)
        end)
        it("should error if any sibling is not found", function()
            local filters = {
                level2 = {Name = "level2"},
                other = {Name = "other"},
                level4 = {Name = "level4"},
            }
            expect(function()
                Collect.siblings(level3, filters)
            end).to.throw()
        end)
    end)

end