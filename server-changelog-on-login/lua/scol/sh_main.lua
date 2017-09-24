local tabx = {}

local tabx

tabx = setmetatable({}, {
     __index = function(self, key)
         for k, v in pairs(self) do
                  if (v.key == key) then
                           return self[k];
                  end;
         end;

         return nil; -- string key doesn't exist
     end,

     __newindex = function(self, key, value)        
          if (type(key) == "string" and type(value) == "table") then
                  table.insert(self, value);
                  self[#self].key = key;
         end;
     end 
});

tabx["1"] = {
	author = "The Godfather",
	desc = [[
Yeni yapılan şikayetleri inceledik ve kola makinesinin olayını değiştirdik:
artık kola makinesi yok.
Böylece açlık daha stabil olacak.
Öneri için kuaviyong'a teşekkürler.
]]


}
tabx["2"] = {
	author = "sucker",
	desc = [[
OH DEDİRTEN YENİLİK: adult swep geldi!
YES!
YES
YESS!
]]
}
tabx["3"] = {
	author = "cometopapa",
	desc = [[
Fahişe için yeni sistem!:
/sexprice yazarak ücreti değiştirebilme özelliği!
fahişe sistemini satın alın: 50tl
]]
}

tabx["4"] = {
	author = "The Godfather",
	desc = [[
Yeni yapılan şikayetleri inceledik ve kola makinesinin olayını değiştirdik:
artık kola makinesi yok.
Böylece açlık daha stabil olacak.
Öneri için kuaviyong'a teşekkürler.
]]


}
tabx["5"] = {
	author = "sucker",
	desc = [[
Yeni joblar.
]]
}
tabx["6"] = {
	author = "cometopapa",
	desc = [[
Yeni joblar.
]]
}

table.sort(tabx, function(a, b) return a.key > b.key end);


if SERVER then

	util.AddNetworkString("changelog_menu")
	util.AddNetworkString("changelog_add")




	hook.Add("PlayerSpawn","Server Changelogs",function(ply)

		PrintMessage( HUD_PRINTCENTER, ply:Nick().." tekrardan doğdu." )
		net.Start("changelog_menu")
		--
		--
		--
		net.Send(ply)

	end)

	net.Receive("changelog_add", function(len,pl)


		local msg = net.ReadString()
		local whodid = pl




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

				net.WriteString((TextEntry:GetValue() or "nothing :D"))

			net.SendToServer()

		end






end

















local function changelogMenu()

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
		for k,v in pairs(tabx) do vversion = vversion + 0.5 end

		for k,v in pairs(tabx) do
			local widht,heigth = surface.GetTextSize(v.desc)
			local background = DScrollPanel:Add( "DButton" )
			background:SetText( "" )
			background:SetTall( heigth + 20 )
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
			local tarih = vgui.Create( "DLabel", background )
			tarih:SetPos( 10, heigth * 0.9999 )

			tarih:SetFont("tre14")
			local fersion = (vversion - k * .5)
			if (fersion < 0) then fersion = 0.1 end
			if (fersion == 1) then fersion = "Inital version" end
			tarih:SetText( v.author.." - "..os.date("%x", 906000490).." - "..os.date("%X", 906000490).." - ".."version: "..fersion.." - ".."patch id="..v.key  )
			tarih:SizeToContents()

			local aciklama = vgui.Create( "RichText", background )
			aciklama:SetPos( 0, 0)
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

			aciklama:AppendText(v.desc)
		end






end


net.Receive("changelog_menu", changelogMenu)