local rgb = Color
scol = scol or {}
	local function tables_exist()
		local query,result
		print("")
		print("==============================================================")
		MsgC( rgb(230, 126, 34), " [scol]: ", rgb(231, 76, 60), " Checking database...\n"  )


		if (sql.TableExists("scol_data")) then
			MsgC( rgb(230, 126, 34), " [scol]: ", rgb(231, 76, 60), " Database ok.\n"  )
		else
			if (!sql.TableExists("scol_data")) then
				query ="CREATE TABLE scol_data( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, log TEXT, date TEXT, time TEXT, staff TEXT )"
				result = sql.Query(query)
				if (sql.TableExists("scol_data")) then
					
					query = "INSERT INTO scol_data( log, date, time, staff ) VALUES( 'Server Changelogs installed!', '"..os.date("%x").."', '"..os.date("%X").."', 'CONSOLE' )"
					result = sql.Query( query )
					if result then

					else
						Msg( sql.LastError( result ) .. "\n" )
					end
				else
					MsgC( rgb(230, 126, 34), " [scol]: ", rgb(231, 76, 60), " Error occured when creating database.\n"  )
					Msg( sql.LastError( result ) .. "\n" )
				end
			end
		end

		print("==============================================================")
		print("")
		
	end
	hook.Add("Initialize", "scol Init", tables_exist)


	function scol:DeleteLog(id)

		if (sql.TableExists("scol_data")) then else return end
		print("id=",id)
		
		sql.Query("DELETE FROM scol_data WHERE id = '"..id.."'")

		print("yay")

	end
	concommand.Add("scol_remove", function(ply, cmd, args)

		if args then else return end
		local id = tonumber(args[1])
		if (id == 1) then return end
		scol:DeleteLog(id)
	end)
