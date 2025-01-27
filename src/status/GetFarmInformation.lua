-- function to update server information
function FarmSimStatus:getFarmInformation()
    Utilities:print("FarmSimStatus:getFarmInformation()")
    if self.DynamicXmlFile == nil then
        Utilities:print("error: xmlFile is nil")
        return
    end
    if g_farmManager ~= nil then
        -- iterate through farms
        for i, farm in ipairs(g_farmManager.farms) do
            local xmlFarmId = "server.farms.id_" .. i .. "."
            if farm.showInFarmScreen == true then
                -- farm infos
                self.DynamicXmlFile:setString(xmlFarmId .. "#name", farm.name)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#farmId", farm.farmId)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#money", farm.money)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#loanMax", farm.loanMax)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#lastMoneySent", farm.lastMoneySent)
                -- farm statistics
                if farm.stats ~= nil and farm.stats.statistics ~= nil then
                    for statName, statValue in pairs(farm.stats.statistics) do
                        if type(statValue) == "table" then
                            if statValue.session ~= nil then
                                self.DynamicXmlFile:setInt(xmlFarmId .. "statistics." .. statName .. "#session", statValue.session)
                            end
                            if statValue.total ~= nil then
                                self.DynamicXmlFile:setInt(xmlFarmId .. "statistics." .. statName .. "#total", statValue.total)
                            end
                        end
                    end
                end
            end
        end
    end
end
