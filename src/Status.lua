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
    -- run hearbeat after one second to allow everything to initialize
    addTimer(30000, "heartbeat", self)
end

-- heartbeat which updates data
function FarmSimStatus:heartbeat()
    Utilities:print("FarmSimStatus:heartbeat()")
    -- create xml file
    self:createDynamicXmlFile()
    -- get information
    self:getServerInformation()
    self:getFarmInformation()
    -- save xml file
    self:saveXmlFile()
    -- re-check at updateInterval
    addTimer(self.updateInterval, "heartbeat", self)
end

-- function to create xml file
function FarmSimStatus:createDynamicXmlFile()
    Utilities:print("FarmSimStatus:createDynamicXmlFile()")
    self.DynamicXmlFile = XMLFile.create("server", self.modDir .. "/" .. self.DynamicXmlName, "server")
end

-- function to save xml file
function FarmSimStatus:saveXmlFile()
    Utilities:print("FarmSimStatus:saveXmlFile()")
    self.DynamicXmlFile:save()
    self.DynamicXmlFile:delete()
end

-- initialize plugin after map load finished
BaseMission.loadMapFinished = Utils.prependedFunction(BaseMission.loadMapFinished, function(...)
    FarmSimStatus:init()
end)
