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
	
	clear()
	
	sertextext.centerDisplay("FireBox")
	local x, y = term.getCursorPos()
	sertextext.center(y+3, "Sertex Team")
	sleep(3)
	clear()
	graphics.header()
	
end

local lock = false

if lock then
	os.pullEvent = os.pullEventRaw
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

os.shutdown()