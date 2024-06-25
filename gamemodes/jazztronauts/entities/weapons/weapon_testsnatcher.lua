if SERVER then
	AddCSLuaFile()

end

SWEP.Base					= "weapon_basehold"
SWEP.PrintName				= JazzLocalize("test snatcher")
SWEP.Slot					= 0
SWEP.Category				= "#jazz.weapon.category"
SWEP.WepSelectIcon			= Material( "weapons/weapon_propsnatcher.png" )
SWEP.Weight				= 22

SWEP.ViewModel				= "models/weapons/c_stunstick.mdl"
SWEP.WorldModel				= "models/weapons/w_stunbaton.mdl"
SWEP.HoldType				= "melee"

SWEP.Primary.Delay			= 0.001
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Sound			= Sound( "weapons/357/357_fire2.wav" )
SWEP.Primary.Automatic		= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo		= "none"


function SWEP:RemoveWorld( position, snatchobj )

	snatchobj:SetMode(2)
	snatchobj:StartWorld( position, self:GetOwner() )

end

function SWEP:SecondaryAttack()

	self.BaseClass.SecondaryAttack( self )

end