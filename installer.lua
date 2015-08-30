term.clear()
term.setCursorPos(1,1)
printError("Warning")
printError("You're trying to install FireBox")
printError("FireBox is bugged")
printError("We're removing the software from your computer (if exists)")
sleep(5)
if fs.exists("/.FireBox")
	fs.delete("/.FireBox")
	printError("Removed FireBox")
else
	printError("FireBox not found")
end

printError("We saved your computer from a bugged software")