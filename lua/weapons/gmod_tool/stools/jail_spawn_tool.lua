TOOL.Category = "Bloody Advanced Jailing"
TOOL.Name = "Jail Spawn Editor"
TOOL.Command = nil
TOOL.ConfigName = nil

local TMODE = TOOL.Mode -- defined by the name of this file
local bAdminJail = bAdminJail

-- Build defaults for the preset system.
local ConVarsDefault = TOOL:BuildConVarList()

--- Setting the tool guns info
if CLIENT then
	TOOL.Information = {

		{ name = "info", stage = 1 },
		{ name = "left" },
		{ name = "right" },
		{ name = "right_use", icon2 = "gui/e.png" },
		{ name = "reload" },
		{ name = "reload_use", icon2 = "gui/e.png" },

	}
	language.Add("Tool." ..TMODE.. ".name", "Jail Spawn Editor")
	language.Add("Tool." ..TMODE.. ".desc", "Spawn and set positions for players to be jailed.")
	language.Add("Tool." ..TMODE.. ".0", "Left Click: Set a position, Right Click: Nothing")
    language.Add("Tool." ..TMODE.. ".model", "Model: ")
    language.Add("Tool." ..TMODE.. ".material", "Material: ")
end
--------------------------------

local function DisplayJailPoints()
end

function TOOL:LeftClick(trace)
	if trace.Hit then
		local trEnt = trace.Entity
		jsp = (trace.HitPos)
		if(SERVER) then
			bAdminJail.jailPositions:Add(jsp) 
		end
		if (CLIENT) then
			hook.Add( "PostDrawTranslucentRenderables", "draw_zm_spawner_box", function()
				render.SetColorMaterial()
				cam.IgnoreZ( true )
				render.DrawBox( jsp, angle_zero, Vector( 2, 2, 2 ), Vector( -2, -2, -2 ), Color( 255, 0, 0) )
				cam.IgnoreZ( false )
			end )
		end
	end

    return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	

	return true
end

function TOOL:Reload(trace)
	if CLIENT then return true end

	return true
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Text = "Example TOOL", Description = "Sets midnight jail spawns." })
 
	panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "ballsocket", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )
end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, 256, 256)

	draw.SimpleText("Jail Spawn Editor", "DermaLarge", 128, 100, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(255, 0, 0), 4)
end

function TOOL:Deploy()
	if SERVER then
		-- Server Code
	end
	if CLIENT then
		-- Client Code 
	end
end

function TOOL:Holster()
	hook.Remove( "PostDrawTranslucentRenderables", "draw_zm_spawner_box" )
end