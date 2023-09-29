-- Written by UzukiShimamura, edited by Kevin Liu and licensed to CL Hotsuki. Partially refactored to avoid conflicts with the mod by Hotsuki.
include("GameCapabilities");

function OnTurnBegin_ResetShift()					-- Every turn a unit can restore its movement once.
    for playerID = 0, GameDefines.MAX_PLAYERS-1, 1 do
        if (not HasTrait("TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER", playerID)) then return; end

		for i, pUnit in Players[playerID]:GetUnits():Members() do
			local unitType = GameInfo.Units[pUnit:GetType()].UnitType
            if (unitType == "UNIT_BUILDER" or unitType == "UNIT_MILITARY_ENGINEER") and (pUnit:GetAbility():GetAbilityCount("ABILITY_KEQING_TVT_OVERTIME_SHIFT") == 0) then
				pUnit:GetAbility():ChangeAbilityCount("ABILITY_KEQING_TVT_OVERTIME_SHIFT", 1)
			end
        end
    end
end

function OnCityMadePurchase_GrantMovement(playerID, cityID, iX, iY, purchaseType, objectType)
	if (purchaseType ~= EventSubTypes.UNIT) then return; end	-- Grant Unit Movement Immediately After Purchase
	if (not HasTrait("TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER", playerID)) then return; end
	local pUnitWithMaxID;
	for i, pUnit in ipairs(Units.GetUnitsInPlot(Map.GetPlot(iX,iY))) do 
	    if not pUnitWithMaxID then
            pUnitWithMaxID = pUnit;
        end
        if pUnitWithMaxID then 
            if pUnit:GetID() > pUnitWithMaxID:GetID()  then -- choose the one that is produced (hopefully) later
                pUnitWithMaxID = pUnit;
            end
        end
	end
    if pUnitWithMaxID then
        if (pUnitWithMaxID:GetType() == objectType) then
            UnitManager.RestoreMovementToFormation(pUnitWithMaxID);
            UnitManager.RestoreUnitAttacks(pUnitWithMaxID);
        else
            for i, pUnit in Players[playerID]:GetUnits():Members() do -- "Unit in this plot" just ignores traders. This branch is for the case when an unit is just at the city.
                if not pUnitWithMaxID then
                    pUnitWithMaxID = pUnit;
                end
                if pUnitWithMaxID then 
                    if pUnit:GetID() > pUnitWithMaxID:GetID()  then 
                        pUnitWithMaxID = pUnit;
                    end
                 end
            end
            UnitManager.RestoreMovementToFormation(pUnitWithMaxID);
            UnitManager.RestoreUnitAttacks(pUnitWithMaxID);
        end
    else
        for i, pUnit in Players[playerID]:GetUnits():Members() do -- while this branch handle the case when no other unit is there.
            if not pUnitWithMaxID then
                pUnitWithMaxID = pUnit;
            end
            if pUnitWithMaxID then 
                if pUnit:GetID() > pUnitWithMaxID:GetID()  then 
                    pUnitWithMaxID = pUnit;
                end
             end
        end
        UnitManager.RestoreMovementToFormation(pUnitWithMaxID);
        UnitManager.RestoreUnitAttacks(pUnitWithMaxID);
    end
end

function OvertimeShiftActionShort(playerID:number, unitID:number)
	local pUnit = Players[playerID]:GetUnits():FindID(unitID);
	if (not pUnit) then return; end
	UnitManager.RestoreMovementToFormation(pUnit);
	pUnit:GetAbility():ChangeAbilityCount("ABILITY_KEQING_TVT_OVERTIME_SHIFT", -1);	
end

function GetOvertimeShiftAbilityCount(playerID:number, unitID:number)
	local pUnit = Players[playerID]:GetUnits():FindID(unitID);
	if (not pUnit) then return; end
	count = pUnit:GetAbility():GetAbilityCount("ABILITY_KEQING_TVT_OVERTIME_SHIFT")
	return count;
end

Events.TurnBegin.Add(OnTurnBegin_ResetShift);
Events.CityMadePurchase.Add(OnCityMadePurchase_GrantMovement);

--ExposedMembers for UI support

ExposedMembers.GameEvents = GameEvents

GameEvents.LiyueInazumaSetPlotProperty.Add(function(plotID, key, value)
    local plot = Map.GetPlotByIndex(plotID)
    plot:SetProperty(key, value)
end)

GameEvents.LiyueInazumaGetPlotProperty.Add(function(plotID, key)
    local plot = Map.GetPlotByIndex(plotID)
    plot:GetProperty(key)
end)

function OnGameTurnStarted()
    ExposedMembers.LIYUEINAZUMA.OnGameTurnStartedRefreshAmenity()
end

ExposedMembers.LIYUEINAZUMA = ExposedMembers.LIYUEINAZUMA or {}
ExposedMembers.LIYUEINAZUMA.OvertimeShiftActionShort = OvertimeShiftActionShort
ExposedMembers.LIYUEINAZUMA.GetOvertimeShiftAbilityCount = GetOvertimeShiftAbilityCount

GameEvents.OnGameTurnStarted.Add(OnGameTurnStarted);
