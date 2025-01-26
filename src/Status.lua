Status = {}
Status_mp = Class(Status)

function Status:new()
    local data = {
        -- mod data
        checkInterval = 1 * 1000 * 60, -- check every minute
        -- xml data
        xmlFile = nil,
        -- game data
        fields = {}
    }
    setmetatable(data, self)
    self.__index = self
    return data
end

-- initialization
function initialize()
    Utils:print("initialize()")
    Status:initialize()
end

function Status:initialize()
    Utils:print("Status:initialize()")
    self:heartbeat()
end

-- heartbeat which updates data
function Status:heartbeat()
    Utils:print("Status:heartbeat()")
    -- create xml file
    self:createXmlFile()
    -- get server information
    self:updateServerInformation()
    -- save xml file
    self:saveXmlFile()
    -- re-check at checkInterval
    addTimer(checkInterval, "heartbeat", self)
end

-- function to create xml file
function Status:createXmlFile()
    Utils:print("Status:createXmlFile()")
    self.xmlFile = XMLFile.create("Server", getUserProfileAppPath() .. "/" .. "FS25_FarmsimStatus.xml", "Server")
end

-- function to save xml file
function Status:saveXmlFile()
    Utils:print("Status:saveXmlFile()")
    self.xmlFile:save()
    self.xmlFile:delete()
end

-- function to update server information
function Status:updateServerInformation()
    Utils:print("Status:updateServerInformation()")
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

-- add initialize function to Mission
FSBaseMission.onStartMission = Utils.appendedFunction(FSBaseMission.onStartMission, initialize)
