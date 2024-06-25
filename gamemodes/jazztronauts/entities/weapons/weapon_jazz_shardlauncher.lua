SWEP.PrintName			= "Shard Launcher" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "The Bartender" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "Suggested by the Cellist when asked for a faster way to steal lots of small brushes in one place."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 99999
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 0
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/c_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.HoldType				= "pistol"

SWEP.UseHands		= true

local ShootSound = Sound( "Weapon_SMG1.Double" )
local ShootSound2 = Sound( "Weapon_Gauss.Fire" )




function SWEP:Initialize()
	self:SetHoldType("shotgun")
end

--
-- Called when the left mouse button is pressed
--
function SWEP:PrimaryAttack()

	-- This weapon is 'automatic'. This function call below defines
	-- the rate of fire. Here we set it to shoot every 0.5 seconds.
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )

	-- Play the shoot sound we precached earlier!
	self:EmitSound( ShootSound )

	-- Call 'FireEntity' on self with this model
	self:FireEntity( "jazz_shard" )

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

end


--
-- Called when the rightmouse button is pressed
--

function SWEP:Reload()
	allcloneguns = ents.FindByClass("weapon_clonegungungun")

	for k, v in pairs(allcloneguns) do	--run the remove command on all clone guns with our owner.
		v:RemoveOnReload(self:GetOwner())
	end
end

--
-- A custom function we added. When you call this the player will fire a chair!
--
function SWEP:FireEntity( weapon )
	--
	-- If we're the client then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if we didn't they would feel a ping delay during multiplayer )
	--
	if ( CLIENT ) then return end

	--
	-- Create a prop_physics entity
	--
	local ent = ents.Create( weapon )


	--
	-- Always make sure that created entities are actually created!
	--
	if ( !IsValid( ent ) ) then return end

	--
	-- Set the entity's model to the passed in model
	--
	--ent:SetModel( model_file )

	--
	-- Set the position to the player's eye position plus 16 units forward.
	-- Set the angles to the player'e eye angles. Then spawn it.
	--
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 80 ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()


	--
	-- Now get the physics object. Whenever we get a physics object
	-- we need to test to make sure its valid before using it.
	-- If it isn't then we'll remove the entity.
	--
	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end


	--
	-- Now we apply the force - so the chair actually throws instead
	-- of just falling to the ground. You can play with this value here
	-- to adjust how fast we throw it.
	--
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 1000
	velocity = velocity + ( VectorRand() * 10 ) -- a random element
	phys:ApplyForceCenter( velocity )

	--
	-- Assuming we're playing in Sandbox mode we want to add this
	-- entity to the cleanup and undo lists. This is done like so.
	--
	--cleanup.Add( self.Owner, "props", ent )

	--undo.Create( "Thrown_Chair" )
	--	undo.AddEntity( ent )
	--	undo.SetPlayer( self.Owner )
	--undo.Finish()
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:SetLaunchedBy(owner)
	self:SetVar("playerwholaunched", owner)
end

function SWEP:RemoveOnReload(thrower)
	original_thrower = self:GetVar("playerwholaunched", "lel") --get our original thrower (player/npc who shot the gun)
	iscarried = false

	if(original_thrower == "lel") then --if output was lel, gun was spawned from tool gun/console/map, ignore.
		return
	else
		--determine if gun is held by a player or npc
		iscarried = self:GetOwner():IsPlayer() and (self:GetOwner():GetWeapon("weapon_clonegungungun") != nil)
		iscarried = iscarried || self:GetOwner():IsNPC() and (self:GetOwner():GetActiveWeapon():GetClass() == "weapon_clonegungungun")
		
	end

	if(thrower == original_thrower and !iscarried) then --if the given thrower shot this gun and it's not being used...
		self:Remove()
	end
end

--
--This forcibly switches weapons when the swep is picked up, for maximum troll power. Has an exception for the admin clone gun.
--
function SWEP:Equip(newowner)
	playerhasadmingun = false

	if(newowner:GetActiveWeapon() != NULL) then --this avoids errors for when the player has no weapons.
		playerhasadmingun = newowner:GetActiveWeapon():GetClass() != "weapon_clonegunmaster"
	end

	if(newowner:IsPlayer() and playerhasadmingun) then
		newowner:SelectWeapon("weapon_clonegungungun")
	end
end

--
--Calls above function when its' only being picked up as ammo.
--
function SWEP:EquipAmmo(newowner)
	self:Equip(newowner)
end