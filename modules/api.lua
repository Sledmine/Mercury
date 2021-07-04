----------------------------------------------------------------------
-- API Consumer
-- Sledmine
-- Consumer for the Vulcano API
----------------------------------------------------------------------
local api = {}

local fdownload = require "Mercury.modules.fdownload"
local requests = require "requests"

api.repositoryHost = "genesis.vadam.net"
api.protocol = "https"
api.vulcanoPath = "api/vulcano"

--- Generate an URL using api definitions
local function vulcanoUrl()
    return api.protocol .. "://" .. api.repositoryHost .. "/" .. api.vulcanoPath
end

--- Simple GET HTTP method
local function get(url)
    --local result, error, headers, status, response = fdownload.get(url)
    local response = requests.get(url)
    return response.status_code, response.text
end

---@param packageLabel string
---@param packageVersion string
function api.getPackage(packageLabel, packageVersion)
    local packageUrl = vulcanoUrl() .. "/" .. packageLabel
    local apiUrl = packageUrl
    if (packageVersion) then
        apiUrl = packageUrl .. "/" .. packageVersion
    end
    dprint(apiUrl)
    return get(apiUrl)
end

---@param packageLabel string
---@param packageVersion string
function api.getUpdate(packageLabel, packageVersion)
    local packageUrl = vulcanoUrl() .. "/" .. packageLabel .. "/update" 
    local apiUrl = packageUrl .. "/" .. packageVersion
    dprint(apiUrl)
    return get(apiUrl)
end

function api.fetch()
    local response = requests.get("http://mercuryce.com/pindex")
    return response.status_code, response.text
end

return api
