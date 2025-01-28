-- function to update farmland information
function FarmSimStatus:getFarmlandInformation()
    Utilities:print("FarmSimStatus:getFarmlandInformation()")
    if self.DynamicXmlFile == nil then
        Utilities:print("error: xmlFile is nil")
        return
    end
    if g_farmlandManager ~= nil then
        -- iterate through farmlands
        for i, farmland in ipairs(g_farmlandManager.farmlands) do
            local xmlFarmlandId = "server.farmlands.id_" .. i
            -- farmland infos
            for farmlandKey, farmlandValue in pairs(farmland) do
                if farmlandValue ~= nil then
                    if type(farmlandValue) == "number" then
                        if math.floor(farmlandValue) == farmlandValue then
                            self.DynamicXmlFile:setInt(xmlFarmlandId .. "#" .. farmlandKey, farmlandValue)
                        else
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. "#" .. farmlandKey, farmlandValue)
                        end
                    elseif type(farmlandValue) == "boolean" then
                        self.DynamicXmlFile:setBool(xmlFarmlandId .. "#" .. farmlandKey, farmlandValue)
                    elseif type(farmlandValue) == "string" then
                        self.DynamicXmlFile:setString(xmlFarmlandId .. "#" .. farmlandKey, farmlandValue)
                    elseif (type(farmlandValue) ~= "table") then
                        Utilities:print("error: farmland->" .. farmlandKey .. "-> value is of " .. type(farmlandValue) .." type (Int/Float/Boolean/String expected)")
                    end
                end
            end
            -- farmland fields
            if farmland.field ~= nil then
                -- field state
                if farmland.field.fieldState ~= nil then
                    for fieldstateKey, fieldstateValue in pairs(farmland.field.fieldState) do
                        if fieldstateValue ~= nil then
                            if type(fieldstateValue) == "number" then
                                if math.floor(fieldstateValue) == fieldstateValue then
                                    self.DynamicXmlFile:setInt(xmlFarmlandId .. ".state#" .. fieldstateKey, fieldstateValue)
                                else
                                    self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".state#" .. fieldstateKey, fieldstateValue)
                                end
                            elseif type(fieldstateValue) == "boolean" then
                                self.DynamicXmlFile:setBool(xmlFarmlandId .. ".state#" .. fieldstateKey, fieldstateValue)
                            elseif type(fieldstateValue) == "string" then
                                self.DynamicXmlFile:setString(xmlFarmlandId .. ".state#" .. fieldstateKey, fieldstateValue)
                            elseif (type(fieldstateValue) ~= "table") then
                                Utilities:print("error: farmland->field->state->" .. fieldstateKey .. "-> value is of " .. type(fieldstateValue) .." type (Int/Float/Boolean/String expected)")
                            end
                        end
                    end
                end
                -- field polygons
                if farmland.field.densityMapPolygon ~= nil and farmland.field.densityMapPolygon.pointsX ~= nil and farmland.field.densityMapPolygon.pointsZ ~= nil then
                    for key, pointX in ipairs(farmland.field.densityMapPolygon.pointsX) do
                        if farmland.field.densityMapPolygon.pointsZ[key] ~= nil then
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".polygons.id_" .. key .. "#x", pointX)
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".polygons.id_" .. key .. "#y", farmland.field.densityMapPolygon.pointsZ[key])
                        end
                    end
                end
            end
        end
    end
end
