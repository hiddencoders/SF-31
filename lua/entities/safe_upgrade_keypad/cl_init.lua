include("shared.lua")
local ply = LocalPlayer()


function ENT:Initialize()

end

function ENT:Draw()
	self:DrawModel()
	
		local text = "Upgrade Keypad"
		
		
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		

		surface.SetFont("HUDNumber5")
		local TextWidth = surface.GetTextSize(text)
		
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang

	TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

	cam.Start3D2D(Pos + Ang:Right() * -15, TextAng, 0.1)
			draw.WordBox(2, -TextWidth*0.5, -30, text, "HUDNumber5", Color(140, 140, 140, 100), Color(255,255,255,255))
		cam.End3D2D()
	
end

function ENT:Think()
	
end