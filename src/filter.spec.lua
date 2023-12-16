local Filter = require(script.Parent.filter)

return function()
    describe("process()", function()
        local level1 = game.Workspace.level1
        local level2 = level1.level2
        local otherLevel2 = level1.other
        local level3 = level2.level3

        it("should return the same list if no filter is provided", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list)
            expect(filteredList).to.be.equal(list)
        end)

        it("should filter by name", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)

        it("should filter by classname", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {className = "Folder"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by tag", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {tag = "level1"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by classname and tag", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {className = "Folder", tag = "level1"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by classname and name", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {className = "Model", name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)

        it("should filter by tag and name", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {tag = "level2", name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)
    end)
end