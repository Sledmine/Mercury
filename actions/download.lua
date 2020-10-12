------------------------------------------------------------------------------
-- Download action
-- Sledmine
-- Download any package file
------------------------------------------------------------------------------
local json = require "cjson"
local glue = require "glue"

local fdownload = require "Mercury.lib.fdownload"

-- Entities importation
local PackageMetadata = require "Mercury.entities.packageMetadata"

-- Main repository url
-- These are global variables with default values to provide override
repositoryHost = repositoryHost or "genesis.vadam.net"
httpProtocol = httpProtocol or "https://"
-- Path for master librarian index
librarianPath = librarianPath or "api/vulcano"

local description = {
    -- General errors
    unknown = "Unknown error.",
    noRepositoryServer = "Repository server can't be reached.",
    noResponseFromServer = "No response from the server.",
    noPackageUrl = "No package url found in repository response.",
    -- Package errors
    packageAlreadyInstalled = "Desired package is already installed.",
    packageNotFound = "Package you are looking for is not in the Mercury repository.",
    -- Dependency error
    dependencyError = "There was a problem at downloading one or more dependencies.",
    -- Merc errors
    mercFileNotExist = "Previously downloaded merc file is not on the expected location.",
    mercDownloadError = "An error occurred at downloading merc file.",
    -- No error
    success = "Package downloaded successfully."
}

--- Download a merc file given package metadata
---@param packageMeta packageMetadata
local function downloadFromMetadata(packageMeta)
    cprint("Downloading " .. packageMeta.name .. "...")
    local packageName = packageMeta.name
    local packageVersion = tostring(packageMeta.version)
    -- //TODO Add mirroring selection for this value
    local mercUrl = packageMeta.mirrors[1]
    local mercOutput = _MERCURY_DOWNLOADS .. "\\" .. packageMeta.label .. ".merc"
    dprint(mercUrl)
    dprint("Mercury url: " .. mercUrl)
    dprint("Mercury output: " .. mercOutput)
    local result, errorCode, headers, status = fdownload.get(mercUrl, mercOutput)
    -- Merc file has been succesfully downloaded
    if (errorCode == 200) then
        if (fileExist(mercOutput)) then
            cprint("Done, " .. packageName .. " - Version " .. packageVersion ..
                       " has been downloaded.")
            return true, description.success, mercOutput
        else
            dprint("Error, '" .. mercOutput .. "' doesn't exist ...")
            return false, description.mercFileNotExist
        end
    else
        -- An error ocurred at downloading merc file
        dprint(headers)
        if (type(errorCode) == "table") then
            cprint("Error, " .. tostring(errorCode[1]) .. " at downloading '" .. packageMeta.url ..
                       "'")
        else
            cprint("Error, " .. tostring(errorCode) .. " at downloading '" .. packageMeta.url .. "'")
        end
        return false, description.mercDownloadError
    end
end

--- Download a package from the repository
---@param packageLabel string
---@param packageVersion string
local function download(packageLabel, packageVersion)
    cprint("Looking for '" .. packageLabel .. "' in Mercury repository... ", true)
    local repositoryUrl = httpProtocol .. repositoryHost .. "/" .. librarianPath
    local packageRequestUrl = repositoryUrl .. "/" .. packageLabel
    if (packageVersion) then
        packageRequestUrl = packageRequestUrl .. "/" .. packageVersion
    end
    dprint("Package Request URL: " .. packageRequestUrl)
    local result, errorCode, headers, status, responseData = fdownload.get(packageRequestUrl)
    if (errorCode == 404) then
        return false, description.noRepositoryServer
    elseif (errorCode == 200) then
        if (headers["content-length"] == "0") then
            -- Server response was empty, package was not found
            return false, description.packageNotFound
        else
            -- Server gave us a response with data
            if (responseData) then
                dprint("Response data:" .. responseData)
                ---@type packageMetadata
                local packageMeta = PackageMetadata:new(responseData)
                if (not packageVersion) then
                    packageVersion = packageMeta.version
                end
                cprint("done.")
                cprint("Name = " .. packageMeta.name .. ", Version = " .. packageVersion)
                -- //TODO Add conflicting packages handle here
                -- Get available mirrors from metadata
                if (packageMeta.mirrors) then
                    local downloadResult, errorDescription, mercPath =
                        downloadFromMetadata(packageMeta)
                    if (not downloadResult) then
                        return false, errorDescription, mercPath
                    end
                    return true, description.success, mercPath
                else
                    return false, description.noPackageUrl
                end
            else
                return false, description.noResponseFromServer
            end
        end
    else
        if (errorCode[1]) then
            cprint("Error - " .. errorCode[1] .. ".")
        else
            cprint(tostring(errorCode))
        end
        return false, description.unknown
    end
end

return download
