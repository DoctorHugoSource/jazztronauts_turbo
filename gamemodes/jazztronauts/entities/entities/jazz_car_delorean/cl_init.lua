print ("delorean cl init")

include("shared.lua")
ENT.GhostModel = ClientsideModel("models/delorean_prop.mdl", RENDERGROUP_OPAQUE)
ENT.GhostModel:SetNoDraw( true )
ENT.GhostModel:SetMaterial( "models/shadertest/shader3" )

ENT.InTimeTravel = false



function ENT:Think()
	self.InTimeTravel = self:GetNetworkedBool( "SCarInTimeTravel" )
	self:Cl_BaseThink()
end


function ENT:Draw()
	if !self.InTimeTravel then
		--self:DrawModel()
		self:Cl_BaseDraw()
	elseif self:GetNetworkedEntity( "SCarCloakOwner" ) == LocalPlayer() then --Draw ghost
		self.GhostModel:SetPos( self:GetPos() )
		self.GhostModel:SetAngles( self:GetAngles() )
		self.GhostModel:DrawModel()
	end
	
end

function ENT:RefreshWorkshopInfo()
	if self:GetWorkshopID() == "" then return end

	-- First download information about the given workshopid
	steamworks.FileInfo( self:GetWorkshopID(), function( result )
		if !IsValid(self) or !result then return end

		self.Title = result.title

		-- Try to get the comments for this workshop
		workshop.FetchComments(result, function(comments)
			if !self then return end
			
			local function parseComment(cmt, width)
				if not cmt then return end

				return markup.Parse(
					"<font=SteamCommentFont>" .. cmt.message .. "</font>\n "
					.."<font=SteamAuthorFont> -" .. cmt.author .. "</font>",
				width)
			end

			-- Select 2 random comments for the side and back of the bus
			self.Description = comments and parseComment(self:TableSharedRandom(comments), 1400)
			self.BackBusComment = comments and parseComment(self:TableSharedRandom(comments, 1), 1400)
		end )

		-- Also try grabbing the thumbnail material
		workshop.FetchThumbnail(result, function(material)
			if !self then return end
			self.ThumbnailMat = material
		end )
	end )
end

