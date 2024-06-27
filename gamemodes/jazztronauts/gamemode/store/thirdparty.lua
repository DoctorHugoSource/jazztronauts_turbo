timer.Simple(0, function() -- Gross, but gives all weapons a chance to register themselves first
	local weps = weapons.GetList()
	local lookup = {}
	for _, v in pairs(weps) do
		lookup[v.ClassName] = v
	end
	local function AddWeapon(name, price, options)
		if not lookup[name] then 
			print("Can't add " .. name .. " to Jazztronauts store. Not registered yet!")
			return 
		end

		options = options or {}
		options.thirdparty = true
		return jstore.Register(lookup[name], price, options)
	end

	-- Wowozela
	AddWeapon("wowozela", 50000, { type = "tool" })

	-- portalgun from seamless portals
	jstore.Register("portal_gun", 200000, {
		cat = "tools",
		name = "Portal Gun",
		desc = "The ultimate Mobility tool Capable of transporting you across an entire map instantly, including even props.",
		thirdparty = true
	})

	-- Shard launcher for destroying maps for fun
		jstore.Register("weapon_jazz_shardlauncher", 300000, {
		cat = "tools",
		name = "Shard Launcher",
		desc = "Launch shards and yoink large amounts of brushes at once! Launched shards do not increase collected shard count.",
		thirdparty = true
	})

	-- Gmod's weapon_base, a surprisingly powerful weapon
		jstore.Register("weapon_base", 500000, {
		cat = "tools",
		name = "Pistol",
		desc = "A pistol found lying by the side of the road in some roleplay map. The Chellist says it's totally cracked, what could that mean?",
		thirdparty = true
	})

	-- The Sonic Screwdriver swep for unlocking and opening doors aswell as manipulating any kind of movable brushes
		jstore.Register("swep_sonicsd", 50000, {
		cat = "tools",
		name = "Sonic Screwdriver",
		desc = "A tool based on sonic technology, capable of unlocking doors, triggering buttons and jumpstarting movable brushes without relying on map triggers.",
		thirdparty = true
	})

	-- The gmod camera, put into the store instead of the inventory by default, to give players the choice to spawn with it or not (reduces inventory clutter)
		jstore.Register("gmod_camera", 100, {
		cat = "tools",
		name = "Camera",
		desc = "An old film camera used by the Singer. For 100 Bux, they'll give it to you to take mémoirs!",
		thirdparty = true
	})

	-- Spawns a scars delorean to reach places like the skybox for ultimate map 100%ing
		jstore.Register("weapon_jazz_deloreanspawner", 1000000, {
		cat = "tools",
		name = "Car Keys",
		desc = "The car keys to some old car. No idea why it's this expensive, but the Pianist said this one can 'take you places'.",
		thirdparty = true
	})

end )
