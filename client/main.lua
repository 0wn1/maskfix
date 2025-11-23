local Cache = { Ped = 0, Mask = -1, Blend = false, Face = false }
local HasTag, SetBlend, SetFace, Unpack = DoesShopPedApparelHaveRestrictionTag, SetPedHeadBlendData, SetPedFaceFeature, table.unpack
local Invoke, Int, Float, Saved, Values = Citizen.InvokeNative, Citizen.PointerValueIntInitialized, Citizen.PointerValueFloatInitialized, {}, {}

for i = 1, 9 do Values[i] = (i < 7) and Int(0) or Float(0) end; local HeadBlendData = { Invoke(0x2746BD9D88C5C5D0, Ped, Unpack(Values)) }

local Resource = GetCurrentResourceName():upper()
local function Log(Type, Action, Text) 
	if Config.Debug then 
		local Colors = { INFO = '^5', SUCCESS = '^2', RESTORE = '^3', ERROR = '^1' }
		print(('%s[%s]^0 %s%s^0%s'):format(Colors[Type] or '^7', Resource, Colors[Type] or '^7', Action, Text and (' ^7| %s'):format(Text) or '')) 
	end 
end

local function Initialize()

	local Ped = PlayerPedId()
	if Cache.Ped ~= Ped then
		Cache = { Ped = Ped, Mask = -1, Blend = false, Face = false, Blend = nil, Face = nil }
		Log('INFO', 'Ped Reloaded', ('ID: %d - Model: %s'):format(Ped, GetEntityArchetypeName(Ped)))
	end

	local Mask = GetPedDrawableVariation(Ped, 1)
	if Cache.Mask == Mask and Cache.Blend and Cache.Face then goto Loop end

	Cache.Mask = Mask

	if Mask > 0 then
		local Hash = GetHashNameForComponent(Ped, 1, Mask, GetPedTextureVariation(Ped, 1))
		local Head = (Hash == 0 or HasTag(Hash, `SHRINK_HEAD`, 0)) or Mask == 108 or Mask == 30
		local Face = (Hash == 0 or not (HasTag(Hash, `HAT`, 0) or HasTag(Hash, `EAR_PIECE`, 0))) and Mask ~= 11 and Mask ~= 114 and Mask ~= 145 and Mask ~= 148

		if Head and not Cache.Blend then
			Saved.Blend = Saved.Blend or HeadBlendData
			if Saved.Blend then
				local Shape = IsPedMale(Ped) and 0 or 21
				SetBlend(Ped, Shape, 0, 0, Saved.Blend[4], Saved.Blend[5], Saved.Blend[6], 0, Saved.Blend[8], 0, false)
				Cache.Blend = true
				Log('SUCCESS', 'Blend Applied', ('Mask: %d | Shape: %d'):format(Mask, Shape))
			end
		elseif not Head and Cache.Blend then
			SetBlend(Ped, Unpack(Saved.Blend, 1, 9), false)
			Cache.Blend = false
			Log('RESTORE', 'Blend Restored', ('Mask: %d'):format(Mask))
		end

		if Face and not Cache.Face then
			if not Saved.Face then
				Saved.Face = {}
				for i = 0, 19 do Saved.Face[i] = GetPedFaceFeature(Ped, i) end
			end
			repeat Wait(0) until HasPedHeadBlendFinished(Ped)
			for i = 0, 19 do SetFace(Ped, i, 0.0) end
			Cache.Face = true
			Log('SUCCESS', 'Face Reset', ('Mask: %d | Features: 20'):format(Mask))
		elseif not Face and Cache.Face then
			for i = 0, 19 do SetFace(Ped, i, Saved.Face[i]) end
			Cache.Face = false
			Log('RESTORE', 'Face Restored', ('Mask: %d | Features: 20'):format(Mask))
		end
	else
		if Cache.Blend then
			SetBlend(Ped, Unpack(Saved.Blend, 1, 9), false)
			Cache.Blend = false
			Log('RESTORE', 'Blend Cleared', 'Mask removed')
		end
		if Cache.Face then
			for i = 0, 19 do SetFace(Ped, i, Saved.Face[i]) end
			Cache.Face = false
			Log('RESTORE', 'Face Cleared', 'Mask removed')
		end
	end

	::Loop::
	SetTimeout(999, Initialize)
end

local function Restore(Name)
	if Resource ~= Name then return end

	local Ped = PlayerPedId()
	if not DoesEntityExist(Ped) then return end

	if Saved.Blend then
		SetBlend(Ped, Unpack(Saved.Blend, 1, 9), false)
		Log('RESTORE', 'Resource Stopped', 'Blend restored')
	end

	if Saved.Face then
		for i = 0, 19 do SetFace(Ped, i, Saved.Face[i]) end
		Log('RESTORE', 'Resource Stopped', 'Face features restored')
	end
end

CreateThread(Initialize)
AddEventHandler('onResourceStop', Restore)
AddEventHandler('onClientResourceStop', Restore)

Log('SUCCESS', 'Initialized', 'System ready')
