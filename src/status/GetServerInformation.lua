-- function to update server information
function FarmSimStatus:getServerInformation()
    Utilities:print("FarmSimStatus:getServerInformation()")
    if self.DynamicXmlFile == nil then
        Utilities:print("error: xmlFile is nil")
        return
    end
    self.DynamicXmlFile:setString("server#lastUpdate", getDate("%Y/%m/%d %H:%M:%S"))
    if g_currentMission ~= nil then
        -- map infos
        local map = g_mapManager:getMapById(g_currentMission.missionInfo.mapId)
        if map ~= nil and map.title ~= nil then
            self.DynamicXmlFile:setString("server.map#name", map.title)
        end
        self.DynamicXmlFile:setInt("server.map#size", g_currentMission.terrainSize)
        if g_currentMission.mapOverlayGenerator ~= nil and g_currentMission.mapOverlayGenerator.farmlandManager ~= nil then
            self.DynamicXmlFile:setInt("server.map#width", g_currentMission.mapOverlayGenerator.farmlandManager.localMapWidth)
            self.DynamicXmlFile:setInt("server.map#height", g_currentMission.mapOverlayGenerator.farmlandManager.localMapHeight)
        end
        -- mission infos
        self.DynamicXmlFile:setBool("server.mission#isServer", g_currentMission:getIsServer())
        if g_currentMission.missionInfo ~= nil then
            self.DynamicXmlFile:setBool("server.mission#isMultiplayer", g_currentMission.missionDynamicInfo.isMultiplayer)
            self.DynamicXmlFile:setString("server.mission#creationDate", g_currentMission.missionInfo.creationDate)
            self.DynamicXmlFile:setBool("server.mission#hasInitiallyOwnedFarmlands", g_currentMission.missionInfo.hasInitiallyOwnedFarmlands)
            self.DynamicXmlFile:setInt("server.mission#autoSaveInterval", g_currentMission.missionInfo.autoSaveInterval)
            self.DynamicXmlFile:setFloat("server.mission#playTime", g_currentMission.missionInfo.playTime)
            self.DynamicXmlFile:setInt("server.mission#initialMoney", g_currentMission.missionInfo.initialMoney)
            self.DynamicXmlFile:setInt("server.mission#initialLoan", g_currentMission.missionInfo.initialLoan)
            self.DynamicXmlFile:setInt("server.mission#growthMode", g_currentMission.missionInfo.growthMode)
            self.DynamicXmlFile:setBool("server.mission#stonesEnabled", g_currentMission.missionInfo.stonesEnabled)
            self.DynamicXmlFile:setBool("server.mission#isSnowEnabled", g_currentMission.missionInfo.isSnowEnabled)
            self.DynamicXmlFile:setBool("server.mission#weedsEnabled", g_currentMission.missionInfo.weedsEnabled)
            self.DynamicXmlFile:setBool("server.mission#stopAndGoBraking", g_currentMission.missionInfo.stopAndGoBraking)
            self.DynamicXmlFile:setBool("server.mission#plowingRequiredEnabled", g_currentMission.missionInfo.plowingRequiredEnabled)
            self.DynamicXmlFile:setBool("server.mission#fruitDestruction", g_currentMission.missionInfo.fruitDestruction)
            self.DynamicXmlFile:setBool("server.mission#limeRequired", g_currentMission.missionInfo.limeRequired)
            self.DynamicXmlFile:setBool("server.mission#trafficEnabled", g_currentMission.missionInfo.trafficEnabled)
            self.DynamicXmlFile:setBool("server.mission#startWithGuidedTour", g_currentMission.missionInfo.startWithGuidedTour)
            self.DynamicXmlFile:setBool("server.mission#automaticMotorStartEnabled", g_currentMission.missionInfo.automaticMotorStartEnabled)
            self.DynamicXmlFile:setBool("server.mission#supportsSaving", g_currentMission.missionInfo.supportsSaving)
            self.DynamicXmlFile:setBool("server.mission#introductionHelpActive", g_currentMission.missionInfo.introductionHelpActive)
            self.DynamicXmlFile:setBool("server.mission#helperBuyFuel", g_currentMission.missionInfo.helperBuyFuel)
            self.DynamicXmlFile:setBool("server.mission#helperBuyFertilizer", g_currentMission.missionInfo.helperBuyFertilizer)
            self.DynamicXmlFile:setBool("server.mission#helperBuySeeds", g_currentMission.missionInfo.helperBuySeeds)
        end
    end
end
