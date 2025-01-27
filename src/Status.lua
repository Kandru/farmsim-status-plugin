FarmSimStatus = {}
FarmSimStatus.modDir = getUserProfileAppPath()
FarmSimStatus.xmlName = "FS25_FarmsimStatus.xml"
FarmSimStatus.xmlFile = nil
FarmSimStatus.updateInterval = 1000 * 60 * 1, -- update every minute

-- initialize plugin
function FarmSimStatus:init()
    Utils:print("FarmSimStatus:init()")
    if (g_currentMission:getIsServer() == false) then
        Utils:print("error: not a server")
        return
    end
    self:heartbeat()
end

-- heartbeat which updates data
function FarmSimStatus:heartbeat()
    Utils:print("FarmSimStatus:heartbeat()")
    -- create xml file
    self:createXmlFile()
    -- get server information
    self:updateServerInformation()
    -- save xml file
    self:saveXmlFile()
    -- re-check at updateInterval
    addTimer(updateInterval, "heartbeat", self)
end

-- function to create xml file
function FarmSimStatus:createXmlFile()
    Utils:print("FarmSimStatus:createXmlFile()")
    self.xmlFile = XMLFile.create("Server", self.modDir .. "/" .. self.xmlName, "Server")
end

-- function to save xml file
function FarmSimStatus:saveXmlFile()
    Utils:print("FarmSimStatus:saveXmlFile()")
    self.xmlFile:save()
    self.xmlFile:delete()
end

-- function to update server information
function FarmSimStatus:updateServerInformation()
    Utils:print("FarmSimStatus:updateServerInformation()")
    if self.xmlFile == nil then
        Utils:print("error: xmlFile is nil")
        return
    end
    local map = g_mapManager:getMapById(g_currentMission.missionInfo.mapId)
    if map == nil or map.title == nil then
        Utils:print("error: map is nil")
    end
    self.xmlFile:setString("server#lastUpdate", getDate("%Y/%m/%d %H:%M:%S"))
    self.xmlFile:setBool("Server.mission#hasInitiallyOwnedFarmlands", g_currentMission.missionInfo.hasInitiallyOwnedFarmlands)
    self.xmlFile:setBool("Server.mission#isMultiplayer", g_currentMission.missionDynamicInfo.isMultiplayer)
    self.xmlFile:setBool("Server.mission#isServer", g_currentMission:getIsServer())
    self.xmlFile:setString("Server.map#name", map.title)
    self.xmlFile:setInt("Server.map#size", g_currentMission.terrainSize)
    self.xmlFile:setInt("Server.map#width", g_currentMission.localMapWidth)
    self.xmlFile:setInt("Server.map#height", g_currentMission.localMapHeight)
end

g_FarmSimStatusPlugin = FarmSimStatus()
addModEventListener(g_FarmSimStatusPlugin)