ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName		= "#jazz_bus_hub"
ENT.Author			= ""
ENT.Information	= ""
ENT.Category		= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model( "models/matt/jazz_trolley.mdl" )


function ENT:SetupDataTables()
	self:NetworkVar("String",	0, "Destination")
	self:NetworkVar("String",	1, "WorkshopID")
	self:NetworkVar("Int",		0, "MapProgress")
end

function ENT:ToProgressMask(mapname)
	local col, total = progress.GetMapShardCount(mapname)
	if not total or total == 0 then return 0 end

	return bit.bor(bit.lshift(total, 16), col)
end

function ENT:FromProgressMask(val)
	local mask = bit.lshift(1, 16) - 1
	return bit.band(val, mask),
		bit.band(bit.rshift(val, 16), mask)
end



function ENT:SetMap(mapname, workshopID)
	self:SetDestination(mapname)
	print ("map setted!!")
	print (mapname)
	GlobalJazzTardisMap = mapname  -- i know global variables are bad but if i use tardisdata here, it's only sent to the tardis when this function runs
								   -- doing it this way means the variable remains accessible even if, say, a tardis wants to access it *after* this function has run
	self:SetWorkshopID(workshopID)																			  -- (like if a tardis is spawned after this function ran)
	self:SetMapProgress(self:ToProgressMask(mapname))			   -- it also means it's accessible to *any* tardis and not only the ones that received the tardisdata
end