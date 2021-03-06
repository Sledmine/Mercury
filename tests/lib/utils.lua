------------------------------------------------------------------------------
-- Utils methods test
-- Sledmine
-- Tests for utils lib
------------------------------------------------------------------------------
local lu = require "luaunit"
inspect = require "inspect"

-- Global modules
require "lib.utils"

testUtils = {}

function testUtils:setUp()
    self.testFilePath = "C:\\Test\\Filename.txt"
    self.testPath = "C:\\Test\\"
    self.testFile = "Filename.txt"
end

function testUtils:testSplitPath()
    local directory, fileName, extension = splitPath(self.testFilePath)
    lu.assertEquals(directory, "C:\\Test")
    lu.assertEquals(fileName, "Filename")
    lu.assertEquals(extension, "txt")
    -- Test only path string type
    directory, fileName, extension = splitPath(self.testPath)
    lu.assertEquals(directory, "C:\\Test")
    lu.assertIsNil(fileName)
    lu.assertIsNil(extension)
    -- Test only file string type
    directory, fileName, extension = splitPath(self.testFile)
    lu.assertIsNil(directory)
    lu.assertEquals(fileName, "Filename")
    lu.assertEquals(extension, "txt")
end

local function runTests()
    local runner = lu.LuaUnit.new()
    runner:runSuite()
end

if (not arg) then
    return runTests
else
    runTests()
end
