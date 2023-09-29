-- By Nea Bajara, modified by UzukiShimamura
include("SupportFunctions")

GameEvents = ExposedMembers.GameEvents

function RefreshAmenityProperty(playerID, cityID)
	local player = Players[playerID]
    local pCity = CityManager.GetCity(playerID, cityID)
    if pCity == nil then 
    	return 
    end
    local cityX = pCity:GetX()
    local cityY = pCity:GetY()
    local CityPlot = Map.GetPlot(cityX, cityY)
    local plotID = CityPlot:GetIndex()
    local pCityGrowth = pCity:GetGrowth()
    local pAmenity = pCityGrowth:GetAmenities() - pCityGrowth:GetAmenitiesNeeded()
	local PROP_HAPPINESS = 'LIYUEINAZUMA_CITY_HAPPINESS'
    if pAmenity ~= nil then 
		local pHappiness = 0;
		if pAmenity >= 3 then
			pHappiness = 1;
		end
		if pAmenity >= 5 then
			pHappiness = 2;
		end
    	GameEvents.LiyueInazumaSetPlotProperty.Call(plotID, PROP_HAPPINESS, pHappiness)
    end
end


function OnGameTurnStartedRefreshAmenity()
	local players = Game.GetPlayers{Alive = true};
	for _, player in ipairs(players) do
		for _, city in player:GetCities():Members() do
			RefreshAmenityProperty(player:GetID(), city:GetID())
		end
	end
end

Events.CityAddedToMap.Add(RefreshAmenityProperty);
ExposedMembers.LIYUEINAZUMA.OnGameTurnStartedRefreshAmenity = OnGameTurnStartedRefreshAmenity