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
                    -- get all polygons of a field
                    local fieldPolygons = {}
                    for key, pointX in ipairs(farmland.field.densityMapPolygon.pointsX) do
                        if farmland.field.densityMapPolygon.pointsZ[key] ~= nil then
                            fieldPolygons[key] = { x = pointX, y = farmland.field.densityMapPolygon.pointsZ[key] }
                        end
                    end
                    -- get the corners of the field (thx ChatGPT Oo, need to check if this works)
                    for key, point in ipairs(fieldPolygons) do
                        local tmpPolygons = {}
                        local startX, startY = point.x, point.y
                        local widthX, widthY = 0, 0
                        local heightX, heightY = 0, 0
                        if key < #fieldPolygons then
                            local nextPoint = fieldPolygons[key + 1]
                            widthX, widthZ = nextPoint.x - startX, nextPoint.y - startZ
                        end
                        if key > 1 then
                            local prevPoint = fieldPolygons[key - 1]
                            heightX, heightZ = startX - prevPoint.x, startZ - prevPoint.y
                        end
                        local corners = {
                            { x = startX, y = startY },
                            { x = startX + widthX, y = startY + widthY },
                            { x = startX + heightX, y = startY + heightY },
                            { x = startX + heightX + widthX, y = startY + widthY + heightY }
                        }
                        for cornerIndex, corner in ipairs(corners) do
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".polygons.id_" .. key .. "#x", corner.x)
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".polygons.id_" .. key .. "#y", corner.y)
                            self.DynamicXmlFile:setFloat(xmlFarmlandId .. ".polygons.id_" .. key .. "#index", cornerIndex - 1)
                        end
                    end
                end
            end
        end
    end
end
