local json = require "cjson"

--- Attempts to found an installed package given packageLabel
---@return packageMercuryJson package
local function searchPackage(packageLabel)
    local installedPackages = environment.packages()
    if (installedPackages and installedPackages[packageLabel]) then
        return installedPackages[packageLabel]
    end
    return false
end

return searchPackage
