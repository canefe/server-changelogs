if SERVER then

	util.AddNetworkString("changelog_menu")
	util.AddNetworkString("changelog_add")
	util.AddNetworkString("changelog_refresh")

	local function refresh(ply)

		local tablex = sql.Query( "SELECT * FROM scol_data")
		
		if (tablex == false) then return end
		local checker = true
		if (tablex == {}) then checker = false tablex = {"nothing"} end
		if checker then table.sort(tablex, function(a, b) return a.id > b.id end) end
		net.Start("changelog_menu")
			if checker then net.WriteTable(tablex) end
		net.Send(ply)

	end
	function scolOpen(ply)

		local tablex = sql.Query( "SELECT * FROM scol_data")
		
		if (tablex == false) then return end
		local checker = true
		if (tablex == nil) then checker = false table = {"nothing"} end
		if checker then table.sort(tablex, function(a, b) return a.id > b.id end) end
		net.Start("changelog_menu")
			if checker then net.WriteTable(tablex) end
		net.Send(ply)

	end

	hook.Add( "PlayerSay", "scol chatcommand", function( ply, text, public )
		text = string.lower( text ) 
		if ( text == "!clog" ) then
			refresh(ply)
			return ""
		end
	end )



	hook.Add("PlayerInitialSpawn","Server Changelogs",function(ply)

		scolOpen(ply)

	end)

	net.Receive("changelog_add", function(len,pl)

		local query,result
		local code = net.ReadString()
		
		local whodid = pl:Nick()

		if (code == "new") then
			local msg = net.ReadString()
			query = "INSERT INTO scol_data( log, date, time, staff ) VALUES( '"..msg.."', '"..os.date("%x").."', '"..os.date("%X").."', '"..whodid.."' )"
			result = sql.Query( query )
			if not (result == false) then
				pl:ChatPrint("Succesfully added.")

				timer.Simple(0.7777, function()

					refresh(pl)

				end)
			else
				pl:ChatPrint( (sql.LastError( result ) or "wtf") )
			end			

		elseif (code == "edit") then

			local id = net.ReadInt(8)
			local msg = net.ReadString()

			local query = "UPDATE scol_data SET log = '"..msg.."' WHERE id = '"..id.."'"
			sql.Query(query)			



		elseif (code == "remove") then


		end







	end)

	net.Receive("changelog_refresh", function(len,pl)

		refresh(pl)

	end)

	bnet.Receive("scol_requestTable" , function(ply,id)
		local request = sql.Query("SELECT * FROM scol_data WHERE id = '"..tonumber(id).."'")
		bnet.Send(ply, "scol_getTable", request)
	end)	


end

if SERVER then return end




local rgb = Color
surface.CreateFont( "tre14", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 14,
} )



local gottasend


	bnet.Receive("scol_getTable" , function(tabled)
		if not istable(tabled) then return end
		gottasend = tabled
	end)


local function GetTableID(id)

	if not id then return end
	bnet.SendToServer("scol_requestTable", id)
	return gottasend
end

local function panelTwo()

    local frame = vgui.Create("flatblur")
	frame:SetSize( 600, 550 )
    frame:SetTitle("New Changelog")
    frame:MakePopup()
    frame:Center()

    frame.OnClose = function(self)

				 timer.Simple(0.777, function()

				 	net.Start("changelog_refresh")

				 	net.SendToServer()

				 end)

	end

	local DLabel = vgui.Create( "DLabel", frame )
		DLabel:SetPos( 172, 512 )
		DLabel:SetText( "Chars Left: "..( 300 ) )
		DLabel:SizeToContents()


	 local TextEntry = vgui.Create( "DTextEntry", frame )
	 TextEntry:SetPos( 8, 25 )
	 TextEntry:SetSize( 583, 480 )
	 TextEntry:SetText( "" )
	 TextEntry:SetMultiline( true )
	 TextEntry.MaxChars = 300
	TextEntry.Paint = function(self)
		surface.SetDrawColor(44, 62, 80,180)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end
	local amt

	TextEntry.OnTextChanged = function(self)
		local txt = self:GetValue()
		local amt = string.len(txt)
		if amt > self.MaxChars then
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
		DLabel:SetText( "Chars Left: "..((self.MaxChars - amt) or 300 - amt ) )
	end

		local DButton = vgui.Create( "flatblurButton", frame )
		DButton:SetPos( 300, 512 )
		DButton:SetText( "Submit" )
		DButton.DoClick = function()

			net.Start("changelog_add")

				net.WriteString("new")
				net.WriteString((TextEntry:GetValue()or "nothing :D"))

			net.SendToServer()
			frame:Remove()

		end






end

local function panelThree(id)


	
	local toble = GetTableID(id)
	timer.Simple(0.5555, function()

	if istable(toble) then

    local frame = vgui.Create("flatblur")
	frame:SetSize( 600, 550 )
    frame:SetTitle("Edit Changelog")
    frame:MakePopup()
    frame:Center()

    function frame:OnClose()

			self:Remove()

				 timer.Simple(0.777, function()

				 	net.Start("changelog_refresh")

				 	net.SendToServer()

				 end)

    end


	local DLabel = vgui.Create( "DLabel", frame )
		DLabel:SetPos( 172, 512 )
		DLabel:SetText( "Chars Left: "..( 300 ) )
		DLabel:SizeToContents()


	 local TextEntry = vgui.Create( "DTextEntry", frame )
	 TextEntry:SetPos( 8, 25 )
	 TextEntry:SetSize( 583, 480 )
	 TextEntry:SetText( "" )
	 TextEntry:SetMultiline( true )
	 TextEntry.MaxChars = 300
	TextEntry.Paint = function(self)
		surface.SetDrawColor(44, 62, 80,180)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end
	local amt
	local oldmsg
	for k,v in pairs(toble) do
		oldmsg = v.log
		TextEntry:SetText(v.log)
		break

	end

	TextEntry.OnTextChanged = function(self)
		local txt = self:GetValue()
		local amt = string.len(txt)
		if amt > self.MaxChars then
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
		DLabel:SetText( "Chars Left: "..((self.MaxChars - amt) or 300 - amt ) )
	end



		local DButton = vgui.Create( "flatblurButton", frame )
		DButton:SetPos( 300, 512 )
		DButton:SetText( "Submit" )
		DButton.DoClick = function()

			net.Start("changelog_add")

				net.WriteString("edit")
				net.WriteInt(id,8)
				local textt = TextEntry:GetValue() or oldmsg					

				net.WriteString(textt)

			net.SendToServer()



			frame:Remove()

				 timer.Simple(0.777, function()

				 	net.Start("changelog_refresh")

				 	net.SendToServer()

				 end)

		end
	else
				 panelThree(id)
	end
	end)






end



local function factCallback(id,pa)

		RunConsoleCommand( "scol_remove", id )

		pa:Remove()

	 timer.Simple(0.777, function()

			net.Start("changelog_refresh")

			net.SendToServer()

		end)

end




local function Dmenux(id,pa)


			local Menu = vgui.Create( "DMenu" )		-- Is the same as vgui.Create( "DMenu" )

			local Remove = Menu:AddOption( "Remove" ) -- Simple option, but we're going to add an icon
			Remove:SetIcon( "icon16/cancel.png" )	-- Icons are in materials/icon16 folder

			Remove.OnMousePressed = function( button, key )
				Derma_Query( "Are you sure to delete this log?", "scol Remove", "Yes", function() factCallback(id,pa) end, "No", function() return end)
				Menu:Remove()
			end

			local Edit = Menu:AddOption( "Edit" ) -- Simple option, but we're going to add an icon
			Edit:SetIcon( "icon16/pencil.png" )	-- Icons are in materials/icon16 folder

			Edit.OnMousePressed = function( button, key )
				panelThree(id)

				pa:Remove()
				LocalPlayer():PrintMessage( HUD_PRINTTALK, "Loading..." )				
				Menu:Remove()
			end

			Menu:SetPos(input.GetCursorPos())

			Menu:Open()

end







local function changelogMenu()
	local tablex = net.ReadTable()
    local frame = vgui.Create("flatblur")
	frame:SetSize( 570, 350 )
    frame:SetTitle("Changelog Menu")
    frame:MakePopup()
    frame:Center()


	if (IsValid(LocalPlayer()) and LocalPlayer():IsAdmin()) then
	    local btn_new = vgui.Create("DButton", frame)
	    btn_new:SetText( "NEW" )
	    btn_new:SetTall(22)
	    btn_new:SetWide(42)
	    btn_new:SetTextColor(Color(255,255,255))
	    btn_new:SetPos( frame:GetWide() - 72, 0 )
	    btn_new.DoClick = function()
	            frame:Close()
	            panelTwo()
	    end
	    btn_new.Paint = function(s, w, h)
	        if s:IsHovered() then 
	            draw.RoundedBox(0,0,0,w,h,rgb(46, 204, 113))
	        else
	            draw.RoundedBox(0,0,0,w,h,rgb(39, 174, 96))
	        end
	    end
	end

		local DScrollPanel = vgui.Create( "DScrollPanel", frame )
		DScrollPanel:SetSize( 565, 300 )
		DScrollPanel:SetPos( 5, 500 )
		DScrollPanel:Dock( FILL )
		DScrollPanel:Center()

		local sbar = DScrollPanel:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, rgb(52, 73, 94,100) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, rgb(192, 57, 43) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, rgb(192, 57, 43) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80) )
		end

		local vversion = 1
		local adminCheck = false
		for k,v in pairs(tablex) do


			if not (tonumber(v.id) == 1) then

				if (IsValid(LocalPlayer()) and LocalPlayer():IsAdmin()) then

					adminCheck = true




			end
			end
			surface.SetFont("tre14")
			local widht,heigth = surface.GetTextSize((v.log))
			local background = DScrollPanel:Add( "DButton" )
			background:SetText( "" )
			background:SetTall( (heigth + 40) + (string.len(v.log) * 0.1) )
			background:SetFont("Trebuchet24")
			background:SetTextColor(Color(255,255,255))
			background:Dock( TOP )
			background:DockMargin( 0, 0, 5, 5 )

			background.Paint = function(s, w, h)
				if s:IsHovered() then 
					draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,230))
				else
					draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,180))
				end
				
				
			end



			



			background.DoClick = function()
				if (tonumber(v.id) == 1) or (adminCheck == false) then return end
				Dmenux(v.id,frame)



			end
		    			

			local aciklama = vgui.Create( "RichText", background )
			aciklama:SetPos(0, 0)
			aciklama:Dock( FILL )
			aciklama:SetTall(background:GetTall() - 10)
			aciklama:SetMouseInputEnabled( false )
			

			function aciklama:PerformLayout()

				self:SetFontInternal( "tre14" )
				self:SetBGColor( Color( 64, 64, 92, 3 ) )


			end
			-- #credit text
			aciklama:InsertColorChange( 255,255,255, 255 )
			aciklama:SetVerticalScrollbarEnabled( false )
			aciklama:SetFontInternal( "tre14" )

			aciklama:AppendText(v.log)

			local tarih = vgui.Create( "DLabel", background )
			
			tarih:Dock( BOTTOM )
			tarih:DockMargin(10,0,0, 4)

			tarih:SetFont("tre14")
			tarih:SetText( v.staff.." - "..v.date.." - "..v.time)
			tarih:SetColor(rgb(149, 165, 166))
			tarih:SizeToContents()



		end






end


net.Receive("changelog_menu", changelogMenu)