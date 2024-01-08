TOOL.Category = "Jail"
TOOL.Name = "Bloody Advanced Jailing"
TOOL.Command = nil
jsp = nil

if CLIENT then
	TOOL.Information = {

		{ name = "info", stage = 1 },
		{ name = "left" },
	}
	language.Add( "tool.jail_spawn_tool.name", "Midnight Jail Spawn Tool" )
	language.Add( "tool.jail_spawn_tool.desc", "This tool with set jail spawn positions." )
	language.Add( "tool.jail_spawn_tool.1", "See information in the context menu" )
	language.Add( "tool.jail_spawn_tool.left", "Select spawn position." )
end

function TOOL:DrawToolScreen( width, height )
	-- Draw black background
	surface.SetDrawColor( Color( 20, 20, 20 ) )
	surface.DrawRect( 0, 0, width, height )

	-- Draw white text in middle
	draw.SimpleText( "Jail Position Spawner", "DermaLarge", width / 2, height / 2, Color( 255, 5, 5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function TOOL.BuildCPanel(panel)
  panel:AddControl("Header", { Text = "Example TOOL", Description = "Sets midnight jail spawns." })
 
  panel:AddControl("button", {
    Label = "Save jail position.",
    Command = "jail_pos_save"
	
	})
end


function TOOL:LeftClick(trace)
	if trace.Hit then
		local trEnt = trace.Entity
		local tg_owner = self:GetOwner()
		jsp = (trace.HitPos)
		if (CLIENT) then
			hook.Add( "PostDrawTranslucentRenderables", "draw_zm_spawner_box", function()
				render.SetColorMaterial()
				render.DrawWireframeSphere(Vector(jsp), 5, 4, 4, Color(255, 0, 0, 255))
			end )
		end
	end
end

function TOOL:Holster()
	hook.Remove( "PostDrawTranslucentRenderables", "draw_zm_spawner_box" )
	jsp = nil
end

function TOOL:RightClick(trace)
	return
end

function send_js_data(ply, cmd, args)
	if(jsp != nil) then
		net.Start("send_jspos")
		net.WriteVector(jsp)
		net.SendToServer()
		ply:ChatPrint("Midnight Gaming: Spawn position has been added at " .. tostring(jsp))
	else
		ply:ChatPrint("Midnight Gaming: Spawn position not selected.")
	end
end

concommand.Add( "jail_pos_save", send_js_data)