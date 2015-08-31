function pixel(x, y, color)
  local ox, oy = term.getCursorPos()
  term.setCursorPos(x, y)
  term.setBackgroundColor(color)
  term.write(" ")
  term.setCursorPos(ox, oy)
end

function line(x, y, x2, y2, color)
  local ox, oy = term.getCursorPos()
  if x == x2 then
    term.setBackgroundColor(color)
    for _y = y, y2 do
      term.setCursorPos(x, _y)
      term.write(" ")
    end
  elseif y == y2 then
    term.setBackgroundColor(color)
    for _x = x, x2 do
      term.setCursorPos(_x, y)
      term.write(" ")
    end
  else
    error("diagonal/other lines not supported")
  end
  term.setCursorPos(ox, oy)
end

function box(x, y, x2, y2, color)
  local ox, oy = term.getCursorPos()
  term.setBackgroundColor(color)
  for _y = y, y2 do
    term.setCursorPos(x, _y)
    term.write(string.rep(" ", (x2 - x) + 1))
  end
  term.setCursorPos(ox, oy)
end

function header()
	function center(y, text ) --from SertexText API
		w, h = term.getSize()
		term.setCursorPos((w - #text) / 2, y)
		write(text)
	end
	local w, h = term.getSize()
	box(1,1,w,3, colors.red)
	term.setTextColor(colors.white)
	center(2, "FireBox")
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
	term.setCursorPos(1,5)
end
