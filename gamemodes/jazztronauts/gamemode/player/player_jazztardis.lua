AddCSLuaFile()

hook.Add("PlayerSpawn", "tardisspawning", function (ply)

local owner = ply


if unlocks.IsUnlocked("store", owner, "swep_sonicsd")

print("unlocked")
end

end)




