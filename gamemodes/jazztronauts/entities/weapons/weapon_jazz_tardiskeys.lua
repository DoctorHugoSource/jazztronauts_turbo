AddCSLuaFile()

SWEP.Spawnable = true
SWEP.Category = "Fun + Games"
SWEP.AdminOnly = false
SWEP.UseHands = true


SWEP.Base = "weapon_base"

SWEP.ViewModel				= "models/weapons/c_bus_summoner.mdl"
SWEP.WorldModel				= "models/weapons/w_bus_summoner.mdl"
SWEP.ViewModelFOV		= 55


SWEP.Primary.Delay = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.Weight = 50
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.PrintName = "TARDIS Keys"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true



function SWEP:PrimaryAttack()

if IsValid(jazztardis) then return end

local ply = self:GetOwner()


    local customData = {
        metadataID = "warriortardis"
    }

jazztardis = TARDIS:SpawnTARDIS(ply, customData)
spawnposjazztardis = jazztardis:GetPos()
jazztardis:SetPos(spawnposjazztardis - Vector(0,0,1000))
jazztardis:SetData("demat",true)
jazztardis:UpdateShadow()
jazztardis:StopSound( "torrentcoolydude/spawn.wav" )

timer.Simple(2, function() 

jazztardis:SetPos(spawnposjazztardis)
jazztardis:Mat()
jazztardis:UpdateShadow()
end)
end


function SWEP:SecondaryAttack()
    jazztardis:Demat()
    timer.Simple(15, function() 
    jazztardis:Remove()
    end)
end

function SWEP:Reload()    -- random testing functions for debugging

-- local ply = self:GetOwner()
--
-- local tardisspawnposj = ply:GetPos()
--
--     jazztardis:SetPos(tardisspawnposj)

-- local ply = self:GetOwner()
--
--             jazztardis:PlayerEnter(ply)

end
