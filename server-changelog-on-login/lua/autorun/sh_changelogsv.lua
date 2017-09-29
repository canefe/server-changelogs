if SERVER then

	util.AddNetworkString("changelog_menu")
	util.AddNetworkString("changelog_add")




	hook.Add("PlayerInitialSpawn","Server Changelogs",function(ply)

		local tablex = sql.Query( "SELECT * FROM scol_data")
		
		if (tablex == false) then return end
		local checker = true
		if (tablex == {}) then checker = false table = {"nothing"} end
		if checker then table.sort(tablex, function(a, b) return a.id > b.id end) end
		net.Start("changelog_menu")
		--
			if checker then net.WriteTable(tablex) end
		--
		net.Send(ply)

	end)

	net.Receive("changelog_add", function(len,pl)

		local query,result
		local code = net.ReadString()
		local msg = net.ReadString()
		local whodid = pl:Nick()

		if (code == "new") then

			query = "INSERT INTO scol_data( log, date, time, staff ) VALUES( '"..msg.."', '"..os.date("%x").."', '"..os.date("%X").."', '"..whodid.."' )"
			result = sql.Query( query )
			if not (result == false) then
				pl:ChatPrint("succesfully added.")
			else
				pl:ChatPrint( (sql.LastError( result ) or "wtf") )
			end			

		elseif (code == "edit") then



		elseif (code == "remove") then


		end







	end)


end

if SERVER then return end
local rgb = Color
surface.CreateFont( "tre14", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 14,
} )
local function panelTwo()

    local frame = vgui.Create("flatblur")
	frame:SetSize( 600, 550 )
    frame:SetTitle("New Changelog")
    frame:MakePopup()
    frame:Center()

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

		end






end

















local function changelogMenu()
	local table = net.ReadTable()
    local frame = vgui.Create("flatblur")
	frame:SetSize( 570, 350 )
    frame:SetTitle("Changelog Menu")
    frame:MakePopup()
    frame:Center()

    frame.OnClose = function()

    	panelTwo()

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
		for k,v in pairs(table) do vversion = vversion + 0.5 end

		for k,v in pairs(table) do
			surface.SetFont("tre14")
			local widht,heigth = surface.GetTextSize((v.log))
			local background = DScrollPanel:Add( "DButton" )
			background:SetText( "" )
			background:SetTall( (heigth + 40) + (string.len(v.log) * 0.1) )
			background:SetFont("Trebuchet24")
			background:SetTextColor(Color(255,255,255))
			background:Dock( TOP )
			background:DockMargin( 0, 0, 0, 5 )
			background.Paint = function(s, w, h)
				if s:IsHovered() then 
					draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,230))
				else
					draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,180))
				end
				
				
			end

			background.DoClick = function()
				panelTwo()

			end

			local aciklama = vgui.Create( "RichText", background )
			aciklama:SetPos(0, 0)
			aciklama:Dock( TOP )
			aciklama:SetTall(100)

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
			--DockMargin(number marginLeft,number marginTop,number marginRight,number marginBottom)

			tarih:SetFont("tre14")
			local fersion = (vversion + v.id * .5)
			if (fersion < 0) then fersion = 0.1 end
			if (fersion == 1) then fersion = "Initital version" end
			tarih:SetText( v.staff.." - "..v.date.." - "..v.time.." - ".."version: "..fersion.." - ".."patch id="..v.id.."  "..widht.."  "..heigth  )
			tarih:SetColor(rgb(46, 204, 113))
			tarih:SizeToContents()


		end






end


net.Receive("changelog_menu", changelogMenu)
