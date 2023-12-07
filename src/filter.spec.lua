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
            local filteredList = Filter.process(list, {Name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)

        it("should filter by ClassName", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {ClassName = "Folder"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by Tag", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {Tag = "level1"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by ClassName and Tag", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {ClassName = "Folder", Tag = "level1"})
            expect(filteredList[1]).to.be.equal(level1)
        end)

        it("should filter by ClassName and Name", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {ClassName = "Model", Name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)

        it("should filter by Tag and Name", function()
            local list = {level1, level2, otherLevel2, level3}
            local filteredList = Filter.process(list, {Tag = "level2", Name = "level2"})
            expect(filteredList[1]).to.be.equal(level2)
        end)
    end)
end