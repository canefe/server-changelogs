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