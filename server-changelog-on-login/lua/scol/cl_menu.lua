PANEL = {}
local matBlurScreen = Material( "pp/blurscreen" )
local rgb = Color

function PANEL:SetTitleColor(color)

    local vlx
    if IsColor(color) then vlx = color else vlx = rgb(255,255,255) end
    self.lblTitle.UpdateColours = function( label, skin )
    label:SetTextStyleColor( vlx )
    end   

end

function PANEL:Init()
    self.btn_close = vgui.Create( "DButton", self ) 
    self:ShowCloseButton(false)
    self:MakePopup()
    self:InvalidateLayout()
    self:SetTitleColor("default") -- I know its equal to white anyway :D
end




function PANEL:PerformLayout()



        self.BaseClass.PerformLayout(self)


        self.btn_close:SetText( "" )
        self.btn_close:SetTall(22)
        self.btn_close:SetWide(22)
        self.btn_close:SetPos( self:GetWide() - 22, 0 )
        self.btn_close.DoClick = function()
                self:Close()
        end
        self.btn_close.Paint = function(s, w, h)
            if s:IsHovered() then 
                draw.RoundedBox(0,0,0,w,h,rgb(231, 76, 60))
            else
                draw.RoundedBox(0,0,0,w,h,rgb(192, 57, 43))
            end
        end 

end

function PANEL:Paint()
    local w, h = self:GetSize()

                surface.SetMaterial( matBlurScreen )
                surface.SetDrawColor( 255, 255, 255, 255 )              
                local wx, wy = self:GetPos()
                local us = wx / ScrW()
                local vs = wy / ScrH()
                local ue = ( wx + w ) / ScrW()
                local ve = ( wy + h ) / ScrH()
        
                local ew = 16
                
                for i = 1, ew do
                    
                    matBlurScreen:SetFloat( "$blur", 1 * 5 * ( i / ew ) )
                    matBlurScreen:Recompute()
                    render.UpdateScreenEffectTexture()
                    surface.DrawTexturedRectUV( 0, 0, w, h, us, vs, ue, ve )
                    
                end

            surface.SetDrawColor( rgb(52, 73, 94, 50) )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( Color( 40, 40, 40, 100 ) )
            surface.DrawOutlinedRect( 0, 0, w, h )
            surface.SetDrawColor( rgb(44, 62, 80) )
            surface.DrawRect( 0, 0, w - 22, 22 )


end

vgui.Register("flatblur", PANEL, "DFrame")

PANEL = {}

AccessorFunc(PANEL, "btnColor", "ButtonColor")

function PANEL:PerformLayout()
    --self:SetFont("Default")
    self:SetTextColor(Color(255, 255, 255, 255))

    self.BaseClass.PerformLayout(self)
end

function PANEL:Paint(w,h)


    if self:IsHovered() then 
        draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,230))
    else
        draw.RoundedBox( 0, 0, 0, w, h, rgb(44, 62, 80,180))
    end

end

vgui.Register("flatblurButton", PANEL, "DButton")

local PANEL = {}
function PANEL:Init()

    local PanelCategory = self

    PanelCategory.Children = {}
    PanelCategory.IsToggled = false

    PanelCategory:SetTall( 35 )
    PanelCategory.Button = vgui.Create( "DButton", PanelCategory )
    PanelCategory.Button:Dock( TOP )
    PanelCategory.Button:DockMargin( 5, 5, 5, 0 )
    PanelCategory.Button:SetHeight( 25 )
    PanelCategory.Button:SetText( "" )

    PanelCategory.Button.DoClick = function() PanelCategory:DoToggle() end

    PanelCategory.Button.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 200 ) )
        draw.SimpleText( PanelCategory.Title, "Trebuchet24", 5, 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

end

-----------------------------------------------------------------
-- [ PAINT ]
-- Better than microsoft paint
-----------------------------------------------------------------

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 1, 0, w - 2, h, Color(5, 5, 5, 200))
end

-----------------------------------------------------------------
-- [ ADD NEW CHILD ]
-- Add new entries
-----------------------------------------------------------------
function PANEL:AddNewChild(element)
    local PanelCategory = self

    if not IsValid(element) then return end
    table.insert(PanelCategory.Children, element)

    --PanelCategory.List:PerformLayout()
end

-----------------------------------------------------------------
-- [ SETUP CHILDREN ]
-- Do a little math calc to determine the height of the cat panel
-----------------------------------------------------------------

function PANEL:SetupChildren()
    local PanelCategory = self
    PanelCategory:SetTall( 25 + PanelCategory.List:GetTall() + 15 )
end
-----------------------------------------------------------------
-- [ TOGGLE OPENED ]
-- Action when category list is toggled open
-----------------------------------------------------------------

function PANEL:ToggleOpened()
    local PanelCategory = self
    PanelCategory.IsToggled = true
    PanelCategory:SizeTo( PanelCategory:GetWide(), 25 + table.Count(PanelCategory.Children) * 200, 0.5, 0.1 )
end

-----------------------------------------------------------------
-- [ TOGGLE CLOSED ]
-- Action when category list is toggled closed
-----------------------------------------------------------------

function PANEL:ToggleClosed()
    local PanelCategory = self
    PanelCategory.IsToggled = false
    PanelCategory:SizeTo( PanelCategory:GetWide(), 35, 0.5, 0.1 )
end

-----------------------------------------------------------------
-- [ DO TOGGLE ]
-- Determine state of category list and perform next state
-----------------------------------------------------------------

function PANEL:DoToggle()
    local PanelCategory = self
    if PanelCategory.IsToggled then
        PanelCategory:ToggleClosed()
    else
        PanelCategory:ToggleOpened()
    end
end

-----------------------------------------------------------------
-- [ HEADER TITLE ]
-- Set the category title in header
-----------------------------------------------------------------

function PANEL:HeaderTitle(catTitle)
    local PanelCategory = self
    PanelCategory.Title = catTitle
end

vgui.Register("scolCategory", PANEL, "DPanel")

PANEL = {}

function PANEL:Init()
    self.Icons = {}
    self.IconMaterials = {}
end

function PANEL:SetText(value)
    -- add some space for the icon
    -- this is really not rigorous
    self.BaseClass.SetText(self, "     " .. value)
    self:SetTextColor( Color( 255, 255, 255 ) )
end

function PANEL:AddChoice(value, icon, data, select)
    local choiceIndex = self.BaseClass.AddChoice(self, value, data, select)
    self.Icons[choiceIndex] = icon or false
    self.IconMaterials[choiceIndex] = icon and Material(icon) or false
    return choiceIndex
end


function PANEL:PaintOver(w, h)
    local selected = self:GetSelectedID()
    local icon = self.IconMaterials[selected]
    if not icon then return end
    local iconSize = 16
    local padding = h/2 - iconSize/2
    surface.SetDrawColor(color_white)
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(padding, padding, iconSize, iconSize)
end

function PANEL:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, Color(44, 62, 80, 180))
end

function PANEL:OpenMenu()
    self.BaseClass.OpenMenu(self)
    local items = self.Menu:GetCanvas():GetChildren()
    for index, item in ipairs(items) do
        local icon = self.Icons[index]
        if not icon then continue end
        item:SetIcon(icon)
    end
end

vgui.Register("DComboBoxIcons", PANEL, "DComboBox")