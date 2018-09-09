local function centerSlow(y, string)
  local w, h = term.getSize()
  local x = (w / 2) - (#string / 2)
  term.setCursorPos(x, y)
  textutils.slowPrint(string) -- leave at default slowPrint speed
end


-- Set up screen
term.setBackgroundColour(colours.white)
term.setTextColour(colours.red)
term.clear()

-- Logo
centerSlow(8, "Welcome to OpenBox")
sleep(2.5)

-- Done, boot to main menu
shell.run("/OpenBox.lua")
