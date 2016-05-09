include("shared.lua")
local ply = LocalPlayer()


function ENT:Initialize()
	timer.Create("halo_update"..self:EntIndex(), 0.5, 0, function() 
		
		if self:GetPager() == true then

			local haloPlyT = {}

				for k,v in pairs ( player.GetAll() ) do
					if v == self:Getowning_ent() then
						table.insert(haloPlyT, v)
					end
					if v:isCP() then
						table.insert(haloPlyT, v)
					end
				end
			 

			hook.Add( "PreDrawHalos", "AddHalos", function()
				local me = {self}

				halo.Add( me, Color( 255, 0, 0 ), 0, 0, 2, true, true )
			end )
		end
	end)
end


function ENT:Draw()
	self:DrawModel()
	
		local cnt =( DarkRP.formatMoney(self:GetAmount()) .. "/"..DarkRP.formatMoney(self:GetMaxStorage()))

		local owner = self:Getowning_ent()
		owner = (IsValid(owner) and owner:Nick()) or "ERROR"
		local text = "Tier II Safe"
		
		
	if self.UseCoolMenu then
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		

		surface.SetFont("HUDNumber5")
		local TextWidth = surface.GetTextSize(text)
		local TextWidth2 = surface.GetTextSize(owner)
		local TextWidth3 = surface.GetTextSize(cnt)
		
		
	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 31.875, Ang, 0.11)
			draw.WordBox(2, -TextWidth*0.5, -30, text, "HUDNumber5", Color(140, 140, 0, 100), Color(255,255,255,255))
			draw.WordBox(2, -TextWidth2*0.5, 18, owner, "HUDNumber5", Color(140, 140, 0, 100), Color(255,255,255,255))
			if self:Getowning_ent() == LocalPlayer() then
			draw.WordBox(2, -TextWidth3*0.5, 64, cnt , "HUDNumber5", Color(140, 140, 0, 100), Color(255,255,255,255))
			end
		cam.End3D2D()
	else
		if math.Distance(ply:GetPos(), self:GetPos()) <= 100 and ply:GetEyeTrace().Entity == self then
			draw.DrawText(owner.."'s "..text, 	"ScoreboardText", ScrW() / 2 - 70, ScrH() - 63, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
			draw.DrawText("Contains:" ..cnt,	"ScoreboardText", ScrW() / 2 - 80, ScrH() - 63, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
	end
end


function ENT:Think()
	
end

function ENT:OnRemove()
	timer.Destroy("halo_update"..self:EntIndex())
end
