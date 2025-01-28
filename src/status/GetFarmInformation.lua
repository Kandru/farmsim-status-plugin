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
                for farmKey, farmValue in pairs(farm) do
                    if farmValue ~= nil and farmKey ~= "password" then
                        if type(farmValue) == "number" then
                            if math.floor(farmValue) == farmValue then
                                self.DynamicXmlFile:setInt(xmlFarmId .. "#" .. farmKey, farmValue)
                            else
                                self.DynamicXmlFile:setFloat(xmlFarmId .. "#" .. farmKey, farmValue)
                            end
                        elseif type(farmValue) == "boolean" then
                            self.DynamicXmlFile:setBool(xmlFarmId .. "#" .. farmKey, farmValue)
                        elseif type(farmValue) == "string" then
                            self.DynamicXmlFile:setString(xmlFarmId .. "#" .. farmKey, farmValue)
                        elseif (type(farmValue) ~= "table") then
                            Utilities:print("error: farm->" .. farmKey .. "-> value is of " .. type(farmValue) .." type (Int/Float/Boolean/String expected)")
                        end
                    end
                end
                -- farm players
                if farm.players ~= nil then
                    for key, player in ipairs(farm.players) do
                        for playerKey, playerValue in pairs(player) do
                            if playerValue ~= nil then
                                if type(playerValue) == "table" then
                                    for entryName, entryValue in pairs(playerValue) do
                                        self.DynamicXmlFile:setBool(xmlFarmId .. ".players.id_" .. key .."." .. playerKey .. "#" .. entryName, entryValue)
                                    end
                                elseif type(playerValue) == "number" then
                                    if math.floor(playerValue) == playerValue then
                                        self.DynamicXmlFile:setInt(xmlFarmId .. ".players.id_" .. key .."#" .. playerKey, playerValue)
                                    else
                                        self.DynamicXmlFile:setFloat(xmlFarmId .. ".players.id_" .. key .."#" .. playerKey, playerValue)
                                    end
                                elseif type(playerValue) == "boolean" then
                                    self.DynamicXmlFile:setBool(xmlFarmId .. ".players.id_" .. key .."#" .. playerKey, playerValue)
                                elseif type(playerValue) == "string" then
                                    self.DynamicXmlFile:setString(xmlFarmId .. ".players.id_" .. key .."#" .. playerKey, playerValue)
                                else
                                    Utilities:print("error: farm->players->" .. key .. "->" .. playerKey .. "-> value is of " .. type(playerValue) .." type (Int/Float/Boolean/String expected)")
                                end
                            end
                        end
                    end
                end
                -- farm contractors
                if farm.contractingFor ~= nil then
                    for farmId, isContractor in ipairs(farm.contractingFor) do
                        self.DynamicXmlFile:setBool(xmlFarmId .. ".contractingFor.id_" .. farmId .."#isContractor", isContractor)
                    end
                end
                -- farm statistics
                if farm.stats ~= nil then
                    for statName, statValue in pairs(farm.stats) do
                        if statValue ~= nil then
                            if type(statValue) ~= "table" then
                                if type(statValue) == "number" then
                                    if math.floor(statValue) == statValue then
                                        self.DynamicXmlFile:setInt(xmlFarmId .. ".statistics#" .. statName, statValue)
                                    else
                                        self.DynamicXmlFile:setFloat(xmlFarmId .. ".statistics#" .. statName, statValue)
                                    end
                                elseif type(statValue) == "boolean" then
                                    self.DynamicXmlFile:setBool(xmlFarmId .. ".statistics#" .. statName, statValue)
                                elseif type(statValue) == "string" then
                                    self.DynamicXmlFile:setString(xmlFarmId .. ".statistics#" .. statName, statValue)
                                else
                                    Utilities:print("error: farm->statistics->" .. statName .. "-> value is of " .. type(statValue) .." type (Int/Float/Boolean/String expected)")
                                end
                            end                            
                        end
                    end
                    if farm.stats.statistics ~= nil then
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
                                        Utilities:print("error: farm->statistics->" .. stat.name .. "-> value is of " .. type(stat.value.session) .." type (Int/Float/Boolean/String expected)")
                                    end
                                end
                            end
                        end
                    end
                    -- farm finances
                    if farm.stats.finances ~= nil then
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
                                elseif (type(farmValue) ~= "table") then
                                    Utilities:print("error: farm->finances->" .. stat.name .. "-> value is of " .. type(stat.value) .." type (Int/Float/Boolean/String expected)")
                                end
                            end
                        end
                    end
                    -- farm finances history
                    if farm.stats.financesHistory ~= nil then
                        for key, stats in ipairs(farm.stats.financesHistory) do
                            -- sort by alphabet
                            local sortedFinances = {}
                            for statName, statValue in pairs(stats) do
                                table.insert(sortedFinances, {name = statName, value = statValue})
                            end
                            table.sort(sortedFinances, function(a, b) return a.name < b.name end)
                            for _, stat in ipairs(sortedFinances) do
                                if stat.value ~= nil then
                                    if type(stat.value) == "number" then
                                        if math.floor(stat.value) == stat.value then
                                            self.DynamicXmlFile:setInt(xmlFarmId .. ".financesHistory.month_" .. key .. "#" .. stat.name, stat.value)
                                        else
                                            self.DynamicXmlFile:setFloat(xmlFarmId .. ".financesHistory.month_" .. key .. "#" .. stat.name, stat.value)
                                        end
                                    elseif type(stat.value) == "boolean" then
                                        self.DynamicXmlFile:setBool(xmlFarmId .. ".financesHistory.month_" .. key .. "#" .. stat.name, stat.value)
                                    elseif type(stat.value) == "string" then
                                        self.DynamicXmlFile:setString(xmlFarmId .. ".financesHistory.month_" .. key .. "#" .. stat.name, stat.value)
                                    elseif (type(farmValue) ~= "table") then
                                        Utilities:print("error: farm->financesHistory->" .. key .."->" .. stat.name .. "-> value is of " .. type(stat.value) .." type (Int/Float/Boolean/String expected)")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
