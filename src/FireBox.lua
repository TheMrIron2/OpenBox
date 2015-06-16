local function crash(reason,message)

	local function center(y, text )
		w, h = term.getSize()
		term.setCursorPos((w - #text) / 2, y)
		write(text)
	end
	os.pullEvent = os.pullEventRaw
	reasons = {
		["bypass"] = "System Bypassed",
		["security"] = "System Security Issue",
		["crash"] = "System Crashed",
		["unknown"] = "Unknown Error",
		["game"] = "A Game Crashed The System"

	}
		term.setBackgroundColor(colors.blue)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.white)
		center(1,"FireBox Crashed:")
		if not reasons or not reasons[reason] then
			center(2,reasons["crash"])
		else
			center(2,reasons[reason])
		end
		
		if not message then
			center(4,"Undefined Crash")
		else
			print("\n\n"..message)
		end
		local x, y = term.getCursorPos()
		center(y+2,"Please reboot system!")
		center(y+3,"Please report the issue here:")
		center(y+4,"https://github.com/Sertex-Team/FireBox/issues")
		while true do
			sleep(0)
		end
end
local function main(...)
	for i, v in ipairs(fs.list("/.FireBox/apis")) do
		if not fs.isDir(v) then
			os.loadAPI("/.FireBox/apis/"..v)
		end
	end
	
	local function clear()
		term.setBackgroundColor(colors.white)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.red)
	end
	
	local function playDisk(dIn)
		sleep(0.1)
		clear()
		graphics.header()
		
		if not dIn then
			clear()
			graphics.header()
			sertextext.center(5, "Insert a disk to play!")
			sleep(2.5)
			mainMenu("games")
		end
		dofile(disk.getMountPath(par).."/fireboxlaunch")
		if not run or not fs.exists(disk.getMountPath(par).."/"..run) then
			clear()
			graphics.header()
			sertextext.center(5, "The inserted disk is not compatible with FireBox")
			disk.eject(par)
			sleep(2)
		else
			if not gameName then
				gameName = "Unknown"
			end
			if not versionGame then
				versionGame = 1
			end
			if not authorGame then
				authorGame = "Unknown"
			end
			logoGame = nil
			clear()
			graphics.header()
			sertextext.center(5, "Loading Game...")
			sleep(1.5)
			term.setBackgroundColor(colors.black)
			term.clear()
			term.setCursorPos(1,1)
			term.setTextColor(colors.white)
			sleep(0.1)
			local ok, err = pcall(function()
				local g = fs.open(disk.getMountPath(par).."/"..run, "r")
				local runGame = g.readAll()
				g.close()
				setfenv(loadstring(runGame),getfenv())()
			end)
			if not ok then
				clear()
				graphics.header()
				sertextext.center(5, "The Game \""..gameName.."\" crashed")
				print(6, "\n"..err)
				local x, y = term.getCursorPos()
				sertextext.center(y+2, "Contact "..authorGame.." and report the error")
				sertextext.center(y+4, "Press Any Key To Continue")
				os.pullEvent("key")
			end
		end
		mainMenu()
	end
	
	local function localGamesList()
		while true do
			clear()
			graphics.header()
			local options = {
				"Worm",
				"Redirection",
				"Tron Game (Multiplayer)",
				"Back",
			}
			
			for k, v in ipairs(peripheral.getNames()) do
				if peripheral.getType(v) == "drive" then
					if disk.hasData(v) then
						if fs.exists(disk.getMountPath(v).."/fireboxlaunch") then
							diskIn = true
							dofile(disk.getMountPath(v).."/fireboxlaunch")
						else
							diskIn = false
						end
					else	
						diskIn = false
				else
					diskIn = false
				end
			end
			
			
			if diskIn then
				if not gameName then
					gameName = "Unknown"
				end
				if not authorGame then
					authorGame = "Unknown"
				end
				table.insert(options, 1, gameName.." - "..authorGame)
			else
				table.insert(options, 1, "Insert Disk")
			end
		
			local opt, ch = ui.menu(options, "Games")
			term.setBackgroundColor(colors.black)
			term.clear()
			term.setCursorPos(1,1)
			term.setTextColor(colors.white)
			if ch == 1 then
				playDisk(diskIn)
			elseif ch == 2 then
				shell.run("/rom/programs/fun/worm")
			elseif ch == 3 then
				shell.run("/rom/programs/fun/advanced/redirection")
			elseif ch == 4 then
				shell.run("/.FireBox/games/trongame/trongame")
			elseif ch == 5 then
				mainMenu()
			end
		end
	end
	
	function mainMenu(se)
		if se then
			if se == "games" then
				localGamesList()
			end
		end
		clear()
		graphics.header()
	
		local options = {
			"Play games", --1
			"Update", --2
			"Shutdown", --3
		}
	
		local opt, ch = ui.menu(options, "Dashboard")
	
		if ch == 1 then
			sleep(0.1)
			localGamesList()
		elseif ch == 2 then
			setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/FireBox/master/installer.lua").readAll()),getfenv())()
		elseif ch == 3 then
			os.shutdown()
		else
			mainMenu()
		end
	end
	
	clear()
	sertextext.centerDisplay("FireBox")
	local x, y = term.getCursorPos()
	sertextext.center(y+3, "Sertex Team")
	sleep(3)
	mainMenu()
end

local lock = false

if lock then
	os.pullEvent = os.pullEventRaw
end

local args = {...}

local argData = {
  ["-u"] = false,
}

if #args > 0 then
  while #args > 0 do
    local arg = table.remove(args, 1)
    if argData[arg] ~= nil then
      argData[arg] = true
    end
  end
end

if argData["-u"] then
 term.clear()
 term.setCursorPos(1,1)
 print("Getting installer...")
 sleep(0.1)
 setfenv(loadstring(http.get("https://raw.github.com/Sertex-Team/FireBox/master/installer.lua").readAll()),getfenv())()
end


-- Check System

if not term.isColor() or pocket or turtle then
	print("FireBox Is Only For Advanced Computers")
	return
end

-- If function main() crashes this script will lock the system

local ok, err = pcall(main)
if not ok then
	crash("crash",err)
end