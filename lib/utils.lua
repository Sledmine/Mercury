------------------------------------------------------------------------------
-- Utils module
-- Authors: Sledmine
-- Some util functions
------------------------------------------------------------------------------
local fs = require "fs"
local path = require "path"
local glue = require "glue"

function splitPath(pathName)
    local dir
    local ext
    local filename
    local pathDir = path.dir(pathName)
    if (pathDir) then
        dir = path.dir(pathName)
    end
    local pathExt = path.ext(pathName)
    if (pathExt) then
        ext = "." .. path.ext(pathName)
    end
    local pathFile = path.file(pathName)
    if (pathFile and ext) then
        filename = string.gsub(pathFile, "." .. pathExt, "")
    end
    return dir, filename, ext
end

function fileToString(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function stringToFile(file, text)
    local f = assert(io.open(file, "w"))
    local content = f:write(text)
    f:close()
end

function createFolder(folderName)
    return fs.mkdir(folderName, true)
end

function move(inputPath, outputPath)
    return fs.move(inputPath, outputPath)
end

function deleteFolder(folderName, withFiles)
    if (withFiles == true) then
        os.execute("rmdir /S /Q \"" .. folderName .. "\"")
    else
        os.execute("rmdir \"" .. folderName .. "\"")
    end
end

function deleteFile(filePath, recursive)
    if (recursive == true) then
        return fs.remove(filePath, true)
    end
    return fs.remove(filePath)
end

function copyFile(sourceFile, destinationFile)
    if (sourceFile ~= nil and destinationFile ~= nil) then
        if (fs.is(sourceFile) == false) then
            cprint("Error, specified source file does not exist!")
            cprint(sourceFile)
            return false
        end
        local sourceF = io.open(sourceFile, "rb")
        local destinationF = io.open(destinationFile, "wb")
        if (sourceF ~= nil and destinationF ~= nil) then
            destinationF:write(sourceF:read("*a"))
            io.close(sourceF)
            io.close(destinationF)
            return true
        end
        if (sourceF == nil) then
            cprint("Error, " .. sourceFile .. " source file can't be opened.")
        end
        if (destinationF == nil) then
            cprint("Error," .. destinationFile .. ", destination file can't be opened.")
        end
        cprint("Error, one of the specified source or destination file can't be opened.")
        return false
    end
    cprint("Error, at trying to copy files, one of the specified paths is null.")
    return false
end

function folderExist(folderPath)
    return fileExist(folderPath)
end

function fileExist(filePath)
    return fs.is(filePath)
end

function isFile(filepath)
    if (path.ext(filepath) == nil) then
        return false
    end
    return true
end

function forEach(t, f, ...)
    tr = {}
    for k, v in pairs(t) do
        glue.append(tr, {f(v, ...)})
    end
    return tr
end

function explode(divider, string) -- Created by: http://richard.warburton.it
    if (divider == nil or divider == "") then
        return 1
    end
    local position, array = 0, {}
    for st, sp in function()
        return string.find(string, divider, position, true)
    end do
        table.insert(array, string.sub(string, position, st - 1))
        position = sp + 1
    end
    table.insert(array, string.sub(string, position))
    return array
end

function arrayPop(array)
    return array[#array]
end
