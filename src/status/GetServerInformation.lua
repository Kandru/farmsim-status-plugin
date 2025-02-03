-- function to update server information
function FarmSimStatus:getServerInformation()
    Utilities:print("FarmSimStatus:getServerInformation()")
    if self.DynamicXmlFile == nil then
        Utilities:print("error: xmlFile is nil")
        return
    end
    local xmlServerId = "server"
    self.DynamicXmlFile:setString(xmlServerId .. "#lastUpdate", getDate("%Y/%m/%d %H:%M:%S"))
    if g_currentMission ~= nil then
        -- map infos
        local map = g_mapManager:getMapById(g_currentMission.missionInfo.mapId)
        if map ~= nil and map.title ~= nil then
            self.DynamicXmlFile:setString(xmlServerId .. ".map#name", map.title)
        end
        self.DynamicXmlFile:setInt(xmlServerId .. ".map#size", g_currentMission.terrainSize)
        if g_currentMission.mapOverlayGenerator ~= nil and g_currentMission.mapOverlayGenerator.farmlandManager ~= nil then
            self.DynamicXmlFile:setInt(xmlServerId .. ".map#width", g_currentMission.mapOverlayGenerator.farmlandManager.localMapWidth)
            self.DynamicXmlFile:setInt(xmlServerId .. ".map#height", g_currentMission.mapOverlayGenerator.farmlandManager.localMapHeight)
        end
        -- mission infos
        if g_currentMission.missionInfo ~= nil then
            for missionKey, missionValue in pairs(g_currentMission.missionInfo) do
                if missionValue ~= nil and missionKey ~= nil and not string.find(tostring(missionKey):lower(), "xml") then
                    if type(missionValue) == "number" then
                        if math.floor(missionValue) == missionValue then
                            self.DynamicXmlFile:setInt(xmlServerId .. "#" .. missionKey, missionValue)
                        else
                            self.DynamicXmlFile:setFloat(xmlServerId .. "#" .. missionKey, missionValue)
                        end
                    elseif type(missionValue) == "boolean" then
                        self.DynamicXmlFile:setBool(xmlServerId .. "#" .. missionKey, missionValue)
                    elseif type(missionValue) == "string" then
                        self.DynamicXmlFile:setString(xmlServerId .. "#" .. missionKey, missionValue)
                    elseif (type(missionValue) ~= "table") then
                        Utilities:print("error: server->" .. missionKey .. "-> value is of " .. type(missionValue) .." type (Int/Float/Boolean/String expected)")
                    end
                end
            end
        end
        -- player infos
        if g_currentMission.userManager.users ~= nil then
            for i, player in ipairs(g_currentMission.userManager.users) do
                for playerKey, playerValue in pairs(player) do
                    if playerValue ~= nil then
                        if type(playerValue) == "number" then
                            if math.floor(playerValue) == playerValue then
                                self.DynamicXmlFile:setInt(xmlServerId .. ".players.id_" .. i .. "#" .. playerKey, playerValue)
                            else
                                self.DynamicXmlFile:setFloat(xmlServerId .. ".players.id_" .. i .. "#" .. playerKey, playerValue)
                            end
                        elseif type(playerValue) == "boolean" then
                            self.DynamicXmlFile:setBool(xmlServerId .. ".players.id_" .. i .. "#" .. playerKey, playerValue)
                        elseif type(playerValue) == "string" then
                            self.DynamicXmlFile:setString(xmlServerId .. ".players.id_" .. i .. "#" .. playerKey, playerValue)
                        elseif (type(playerValue) ~= "table") then
                            Utilities:print("error: server->player->id_" ..  i .. "->" .. playerKey .. "-> value is of " .. type(playerValue) .." type (Int/Float/Boolean/String expected)")
                        end
                    end
                end
            end
        end
    end
end
