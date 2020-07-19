local zip = require 'minizip'

local function unpack(mercFile, outputPath)
    local dir, file, ext = splitPath(mercFile)
    cprint("Unpacking " .. file .. "...")
    dprint('mercFile: ' .. mercFile .. 'outputPath: ' .. outputPath)
    mercZip = zip.open(mercFile, 'r')

    -- Set current file as first file
    mercZip:first_file()

    -- Store quantity of files in the zip
    local entries = mercZip:get_global_info().entries

    local fileCount = 0
    for i = 1, entries do
        -- Store current file name
        local fileName = mercZip:get_file_info().filename

        if (fileName ~= 'manifest.json') then
            dprint('Current entry: ' .. i - 1 .. '/' .. entries - 1)
            dprint("Decompressing '" .. fileName .. "'...")
        end

        -- Current "file" is a folder create it
        if (not isFile(fileName)) then
            dprint("Creating folder: '" .. fileName .. "'")
            createFolder(outputPath .. '\\' .. fileName)
        else
            -- Current file is indeed a file, just write it
            dprint('Current decompressed file path: ' .. outputPath .. '\\' .. fileName)
            local file = io.open(outputPath .. '\\' .. fileName, 'wb')
            file:write(mercZip:extract(fileName))
            file:close()
        end

        -- Iterate with next file
        fileCount = fileCount + 1
        mercZip:next_file()
    end

    -- Close zip file
    mercZip:close()

    
    if (fileCount == entries) then
        cprint("Done, " .. file .. " has been unpacked!")
        return true
    end
    cprint("An error ocurred at depacking '" .. mercFile .. "'!")
    return false
end

return unpack
