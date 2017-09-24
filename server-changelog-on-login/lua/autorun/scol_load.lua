local zdiag = {
    '\n\n',
    [[====================================================================]],
}
local loadingtext = {
    [[Loading serverChangelogs...]],
    [[Version loaded: 0.1 ]],
    [[Created by: cometopapa]],
    [[License to: ALPHA-RELEASE]]
}
local ydiag = {
    [[====================================================================]],
}

for k, i in ipairs( zdiag ) do 
    MsgC( Color( 255, 255, 0 ), i .. '\n' )
end

for k, i in ipairs( loadingtext ) do 
    MsgC( Color( 255, 255, 255 ), i .. '\n' )
end

for k, i in ipairs( ydiag ) do 
    MsgC( Color( 255, 255, 0 ), i .. '\n\n' )
end

if CLIENT then
	local files = file.Find( "scol/*", "LUA" )
	for _,v in pairs(files) do
		if string.StartWith(v,"cl_") then
			include("scol/" .. v)
			MsgC(Color(255, 255, 0), "[scol] Loading Client file: " .. v .. "\n")

		elseif string.StartWith(v,"sh_") then
			include("scol/" .. v)
			MsgC(Color(255, 255, 0), "[scol] Loading Shared file: " .. v .. "\n")
		end
	end	

end

if SERVER then
	local files = file.Find( "scol/*", "LUA" )
	for _,v in pairs(files) do
		if string.StartWith(v,"cl_") then
			AddCSLuaFile("scol/" .. v)
			MsgC(Color(255, 255, 0), "[scol] Loading Client file: " .. v .. "\n")
		elseif string.StartWith(v,"sh_") then
			AddCSLuaFile("scol/" .. v)
			include("scol/" .. v)
			MsgC(Color(255, 255, 0), "[scol] Loading Shared file: " .. v .. "\n")
		elseif string.StartWith(v,"sv_") then
			include("scol/" .. v)
			MsgC(Color(255, 255, 0), "[scol] Loading Server file: " .. v .. "\n")
		end
	end
end