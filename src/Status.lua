FarmSimStatus = {}
FarmSimStatus.modDir = getUserProfileAppPath()
FarmSimStatus.DynamicXmlName = "FS25_FarmsimStatusDynamic.xml"
FarmSimStatus.DynamicXmlFile = nil
FarmSimStatus.updateInterval = 1000 * 60 * 1 -- update every minute

-- initialize plugin
function FarmSimStatus:init()
    Utilities:print("FarmSimStatus:init()")
    if (g_currentMission:getIsServer() == false) then
        Utilities:print("error: not a server")
        return
    end
    self:heartbeat()
end

-- heartbeat which updates data
function FarmSimStatus:heartbeat()
    Utilities:print("FarmSimStatus:heartbeat()")
    -- create xml file
    self:createDynamicXmlFile()
    -- get server information
    self:updateServerInformation()
    -- save xml file
    self:saveXmlFile()
    -- re-check at updateInterval
    addTimer(self.updateInterval, "heartbeat", self)
end

-- function to create xml file
function FarmSimStatus:createDynamicXmlFile()
    Utilities:print("FarmSimStatus:createDynamicXmlFile()")
    self.DynamicXmlFile = XMLFile.create("Server", self.modDir .. "/" .. self.DynamicXmlName, "Server")
end

-- function to save xml file
function FarmSimStatus:saveXmlFile()
    Utilities:print("FarmSimStatus:saveXmlFile()")
    self.DynamicXmlFile:save()
    self.DynamicXmlFile:delete()
end

-- function to update server information
function FarmSimStatus:updateServerInformation()
    Utilities:print("FarmSimStatus:updateServerInformation()")
    if self.DynamicXmlFile == nil then
        Utilities:print("error: xmlFile is nil")
        return
    end
    self.DynamicXmlFile:setString("server#lastUpdate", getDate("%Y/%m/%d %H:%M:%S"))
    if g_currentMission ~= nil then
        -- map infos
        local map = g_mapManager:getMapById(g_currentMission.missionInfo.mapId)
        if map ~= nil and map.title ~= nil then
            self.DynamicXmlFile:setString("Server.map#name", map.title)
        end
        self.DynamicXmlFile:setInt("Server.map#size", g_currentMission.terrainSize)
        if g_currentMission.mapOverlayGenerator ~= nil and g_currentMission.mapOverlayGenerator.farmlandManager ~= nil then
            self.DynamicXmlFile:setInt("Server.map#width", g_currentMission.mapOverlayGenerator.farmlandManager.localMapWidth)
            self.DynamicXmlFile:setInt("Server.map#height", g_currentMission.mapOverlayGenerator.farmlandManager.localMapHeight)
        end
        -- mission infos
        self.DynamicXmlFile:setBool("Server.mission#isServer", g_currentMission:getIsServer())
        if g_currentMission.missionInfo ~= nil then
            self.DynamicXmlFile:setBool("Server.mission#isMultiplayer", g_currentMission.missionDynamicInfo.isMultiplayer)
            self.DynamicXmlFile:setString("Server.mission#creationDate", g_currentMission.missionInfo.creationDate)
            self.DynamicXmlFile:setBool("Server.mission#hasInitiallyOwnedFarmlands", g_currentMission.missionInfo.hasInitiallyOwnedFarmlands)
            self.DynamicXmlFile:setInt("Server.mission#autoSaveInterval", g_currentMission.missionInfo.autoSaveInterval)
            self.DynamicXmlFile:setFloat("Server.mission#playTime", g_currentMission.missionInfo.playTime)
            self.DynamicXmlFile:setInt("Server.mission#initialMoney", g_currentMission.missionInfo.initialMoney)
            self.DynamicXmlFile:setInt("Server.mission#initialLoan", g_currentMission.missionInfo.initialLoan)
            self.DynamicXmlFile:setInt("Server.mission#growthMode", g_currentMission.missionInfo.growthMode)
            self.DynamicXmlFile:setBool("Server.mission#stonesEnabled", g_currentMission.missionInfo.stonesEnabled)
            self.DynamicXmlFile:setBool("Server.mission#isSnowEnabled", g_currentMission.missionInfo.isSnowEnabled)
            self.DynamicXmlFile:setBool("Server.mission#weedsEnabled", g_currentMission.missionInfo.weedsEnabled)
            self.DynamicXmlFile:setBool("Server.mission#stopAndGoBraking", g_currentMission.missionInfo.stopAndGoBraking)
            self.DynamicXmlFile:setBool("Server.mission#plowingRequiredEnabled", g_currentMission.missionInfo.plowingRequiredEnabled)
            self.DynamicXmlFile:setBool("Server.mission#fruitDestruction", g_currentMission.missionInfo.fruitDestruction)
            self.DynamicXmlFile:setBool("Server.mission#limeRequired", g_currentMission.missionInfo.limeRequired)
            self.DynamicXmlFile:setBool("Server.mission#trafficEnabled", g_currentMission.missionInfo.trafficEnabled)
            self.DynamicXmlFile:setBool("Server.mission#startWithGuidedTour", g_currentMission.missionInfo.startWithGuidedTour)
            self.DynamicXmlFile:setBool("Server.mission#automaticMotorStartEnabled", g_currentMission.missionInfo.automaticMotorStartEnabled)
            self.DynamicXmlFile:setBool("Server.mission#supportsSaving", g_currentMission.missionInfo.supportsSaving)
            self.DynamicXmlFile:setBool("Server.mission#introductionHelpActive", g_currentMission.missionInfo.introductionHelpActive)
            self.DynamicXmlFile:setBool("Server.mission#helperBuyFuel", g_currentMission.missionInfo.helperBuyFuel)
            self.DynamicXmlFile:setBool("Server.mission#helperBuyFertilizer", g_currentMission.missionInfo.helperBuyFertilizer)
            self.DynamicXmlFile:setBool("Server.mission#helperBuySeeds", g_currentMission.missionInfo.helperBuySeeds)
        end
    end
end

-- initialize plugin after map load finished
BaseMission.loadMapFinished = Utils.prependedFunction(BaseMission.loadMapFinished, function(...)
    FarmSimStatus:init()
end)
