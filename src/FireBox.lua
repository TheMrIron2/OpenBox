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
		
			local opt, ch = ui.menu(options, "Local Games")
			if ch == 1 then
				shell.run("/rom/programs/fun/worm")
			elseif ch == 2 then
				shell.run("/rom/programs/fun/advanced/redirection")
			elseif ch == 3 then
				shell.run("/.FireBox/games/trongame/trongame")
			elseif ch == 4 then
				mainMenu()
			end
		end
	end
	
	local function playDisk()
		sleep(0.1)
		clear()
		graphics.header()
		sertextext.center(5, "Insert a disk or press backspace to cancel")
		while true do
			local e, par = os.pullEvent()
			if e == "disk" then
				if not disk.hasData(par) then
					clear()
					graphics.header()
					sertextext.center(5, "The inserted disk has no data")
					disk.eject(par)
					sleep(2)
				else
					if not fs.exists(disk.getMountPath(par).."/fireboxlaunch") then
						clear()
						graphics.header()
						sertextext.center(5, "The inserted disk is not compatible with FireBox")
						disk.eject(par)
						sleep(2)
					else
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
							clear()
							graphics.header()
							sertextext.center(5, "Loading Game...")
							sleep(1.5)
							term.setBackgroundColor(colors.black)
							term.clear()
							term.setCursorPos(1,1)
							term.setTextColor(colors.white)
							sleep(0.1)
							local function runGame()
								local g = fs.open(disk.getMountPath(par).."/"..run, "r")
								local runGame = g.readAll()
								g.close()
								setfenv(loadstring(g),getfenv())()
							end
							local ok, err = pcall(runGame)
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
				end
			elseif e == "key" and par == 14 then
				sleep(0.1)
				mainMenu()
			end
		end
		mainMenu()
	end
	
	function mainMenu()
		clear()
		graphics.header()
	
		local options = {
			"Play local games", --1
			"Play disk", --2
			"Shutdown", --3
		}
	
		local opt, ch = ui.menu(options, "Dashboard")
	
		if ch == 1 then
			sleep(0.1)
			localGamesList()
		elseif ch == 2 then
			sleep(0.1)
			playDisk()
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