------------------------------------------------------------------------------
-- Utils module
-- Authors: Sledmine
-- Some util functions
------------------------------------------------------------------------------
local fs = require "fs"
local path = require "path"
local glue = require "glue"

--- Overloaded color printing function
function cprint(message, nextLine)
    if (type(message) == "table" or not message) then
        print(inspect(message))
    else
        local messageWithColor = string.gsub(message, "Done", "[92mDone[0m")
        messageWithColor = string.gsub(messageWithColor, "done.", "[92mdone[0m.")
        messageWithColor = string.gsub(messageWithColor, "Downloading",
                                       "[94mDownloading[0m")
        messageWithColor = string.gsub(messageWithColor, "Success", "[92mSuccess[0m")
        messageWithColor =
            string.gsub(messageWithColor, "Searching", "[94mSearching[0m")
        messageWithColor = string.gsub(messageWithColor, "Error", "[91mError[0m")
        messageWithColor = string.gsub(messageWithColor, "Warning", "[93mWarning[0m")
        messageWithColor =
            string.gsub(messageWithColor, "Unpacking", "[93mUnpacking[0m")
        messageWithColor =
            string.gsub(messageWithColor, "Inserting", "[93mInserting[0m")
        messageWithColor = string.gsub(messageWithColor, "Bundling", "[93mBundling[0m")
        messageWithColor =
            string.gsub(messageWithColor, "Compiling", "[93mCompiling[0m")
        messageWithColor = string.gsub(messageWithColor, "Removing", "[91mRemoving[0m")
        io.write(messageWithColor)
        if (not nextLine) then
            io.write("\n")
        end
    end
end

--- Debug print for testing purposes only
function dprint(value)
    if (IsDebugModeEnabled and value) then
        if (type(value) == "table") then
            print(inspect(value))
        else
            cprint(value)
        end
    end
end

--- Provide simple list/array iterator
function each(t)
    local i = 0
    local n = #t
    return function()
        i = i + 1
        if i <= n then
            return t[i], i
        end
    end
end

function splitPath(inputPath)
    local inputPath = gpath(inputPath)
    dprint("Splitting path: " .. inputPath)
    if (inputPath) then
        local directory = path.dir(inputPath)
        if (directory == ".") then
            directory = nil
        end
        local fileName = path.file(inputPath)
        local extension = path.ext(inputPath)
        dprint("directory:  " .. tostring(directory))
        dprint("fileName:  " .. tostring(fileName))
        dprint("extension:  " .. tostring(extension))
        if (fileName and fileName ~= "" and extension) then
            fileName = string.gsub(fileName, "." .. extension, "")
        else
            fileName = nil
        end
        return directory, fileName, extension
    end
    error("No given file or folder path to split!")
end

function createFolder(folderPath)
    if (not exist(folderPath)) then
        dprint("Creating folder: " .. folderPath)
        return fs.mkdir(folderPath, true)
    else
        dprint("Warning, folder " .. folderPath .. " already exists.")
    end
end

function move(sourceFile, destinationFile)
    return fs.move(sourceFile, destinationFile)
end

function delete(fileOrFolderPath, recursive)
    if (recursive) then
        return fs.remove(fileOrFolderPath, true)
    end
    return fs.remove(fileOrFolderPath)
end

function copyFile(sourceFile, destinationFile)
    if (sourceFile and destinationFile) then
        if (fs.is(sourceFile) == false) then
            cprint("Error, specified source file does not exist!")
            cprint(sourceFile)
            return false
        end
        local sourceF = io.open(sourceFile, "rb")
        local destinationF = io.open(destinationFile, "wb")
        if (sourceF and destinationF) then
            destinationF:write(sourceF:read("*a"))
            io.close(sourceF)
            io.close(destinationF)
            return true
        end
        if (not sourceF) then
            dprint("Error, " .. sourceFile .. " source file can't be opened.")
        end
        if (not destinationF) then
            dprint("Error, file: \"" .. destinationFile .. "\" can't be opened.")
        end
        return false
    end
    cprint("Error, at trying to copy files, one of the specified paths is null.")
    return false
end

function exist(fileOrFolderPath)
    return fs.is(fileOrFolderPath)
end

function isFile(filePath)
    return path.ext(filePath)
end

--- Return a Unix like path from a Windows path
function upath(windowspath)
    return windowspath:gsub("\\", "/")
end

--- Return a Windows path from a Unix path
function wpath(unixpath)
    return unixpath:gsub("/", "\\")
end

function gpath( ...)
    local args = { ... }
    local stringPath = ""
    if (args) then
        for _, currentPath in pairs(args) do
            if (jit.os == "Windows") then
                stringPath = stringPath .. wpath(currentPath)
            else
                stringPath = stringPath .. upath(currentPath)
            end
        end
    end
    return stringPath
end