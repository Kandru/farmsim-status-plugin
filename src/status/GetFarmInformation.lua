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
            local xmlFarmId = "server.farms.id_" .. i
            if farm.showInFarmScreen == true then
                -- farm infos
                self.DynamicXmlFile:setString(xmlFarmId .. "#name", farm.name)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#farmId", farm.farmId)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#money", farm.money)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#loanMax", farm.loanMax)
                self.DynamicXmlFile:setInt(xmlFarmId .. "#lastMoneySent", farm.lastMoneySent)
                -- farm players
                if farm.players ~= nil then
                    for _, player in ipairs(farm.players) do
                        self.DynamicXmlFile:setString(xmlFarmId .. ".players." .. player.userId .. "#uniqueUserId", player.uniqueUserId)
                        self.DynamicXmlFile:setString(xmlFarmId .. ".players." .. player.userId .. "#lastNickname", player.lastNickname)
                        self.DynamicXmlFile:setString(xmlFarmId .. ".players." .. player.userId .. "#timeLastConnected", player.timeLastConnected)
                        self.DynamicXmlFile:setBool(xmlFarmId .. ".players." .. player.userId .. "#isFarmManager", player.isFarmManager)
                        -- player permissions
                        if player.permissions ~= nil then
                            for permName, permValue in pairs(player.permissions) do
                                self.DynamicXmlFile:setBool(xmlFarmId .. ".players." .. player.userId .. ".permissions#" .. permName, permValue)
                            end
                        end
                    end
                end
                -- farm statistics
                if farm.stats ~= nil and farm.stats.statistics ~= nil then
                    -- sort by alphabet
                    local sortedStatistics = {}
                    for statName, statValue in pairs(farm.stats.statistics) do
                        table.insert(sortedStatistics, {name = statName, value = statValue})
                    end
                    table.sort(sortedStatistics, function(a, b) return a.name < b.name end)
                    for _, stat in ipairs(sortedStatistics) do
                        if type(stat.value) == "table" then
                            if stat.value.session ~= nil and stat.value.total ~= nil then
                                if type(stat.value.session) == "number" then
                                    if math.floor(stat.value.session) == stat.value.session then
                                        self.DynamicXmlFile:setInt(xmlFarmId .. ".statistics." .. stat.name .. "#session", stat.value.session)
                                        self.DynamicXmlFile:setInt(xmlFarmId .. ".statistics." .. stat.name .. "#total", stat.value.total)
                                    else
                                        self.DynamicXmlFile:setFloat(xmlFarmId .. ".statistics." .. stat.name .. "#session", stat.value.session)
                                        self.DynamicXmlFile:setFloat(xmlFarmId .. ".statistics." .. stat.name .. "#total", stat.value.total)
                                    end
                                elseif type(stat.value.session) == "boolean" then
                                    self.DynamicXmlFile:setBool(xmlFarmId .. ".statistics." .. stat.name .. "#session", stat.value.session)
                                    self.DynamicXmlFile:setBool(xmlFarmId .. ".statistics." .. stat.name .. "#total", stat.value.total)
                                elseif type(stat.value.session) == "string" then
                                    self.DynamicXmlFile:setString(xmlFarmId .. ".statistics." .. stat.name .. "#session", stat.value.session)
                                    self.DynamicXmlFile:setString(xmlFarmId .. ".statistics." .. stat.name .. "#total", stat.value.total)
                                else
                                    Utilities:print("error: farm->statistics->" .. stat.name .. "->value is of " .. type(stat.value.session) .." type (Int/Float/Boolean/String expected)")
                                end
                            end
                        end
                    end
                end
                -- farm finances
                if farm.stats ~= nil and farm.stats.finances ~= nil then
                    -- sort by alphabet
                    local sortedFinances = {}
                    for statName, statValue in pairs(farm.stats.finances) do
                        table.insert(sortedFinances, {name = statName, value = statValue})
                    end
                    table.sort(sortedFinances, function(a, b) return a.name < b.name end)
                    for _, stat in ipairs(sortedFinances) do
                        if stat.value ~= nil then
                            
                            if type(stat.value) == "number" then
                                if math.floor(stat.value) == stat.value then
                                    self.DynamicXmlFile:setInt(xmlFarmId .. ".finances#" .. stat.name, stat.value)
                                else
                                    self.DynamicXmlFile:setFloat(xmlFarmId .. ".finances#" .. stat.name, stat.value)
                                end
                            elseif type(stat.value) == "boolean" then
                                self.DynamicXmlFile:setBool(xmlFarmId .. ".finances#" .. stat.name, stat.value)
                            elseif type(stat.value) == "string" then
                                self.DynamicXmlFile:setString(xmlFarmId .. ".finances#" .. stat.name, stat.value)
                            else
                                Utilities:print("error: farm->finances->" .. stat.name .. "->value is of " .. type(stat.value) .." type (Int/Float/Boolean/String expected)")
                            end
                        end
                    end
                end
            end
        end
    end
end
