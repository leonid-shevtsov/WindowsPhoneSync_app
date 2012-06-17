set target_folder_name to "/Users/leonid/Windows Phone"
set sync_folder_name to "/Users/leonid/wp7-sync-temp"

display dialog "Preparing to sync your Windows Phone contents. Do not touch the computer until the operation is complete." buttons {"Continue"}

do shell script "mkdir -p '" & target_folder_name & "'"
do shell script "rm -rf '" & sync_folder_name & "'"
do shell script "mkdir -p '" & sync_folder_name & "'"


tell application "Finder"
	activate
	set wp7 to make Finder window to (sync_folder_name as POSIX file)
	set the current view of wp7 to icon view
	set bounds of wp7 to {0, 0, 200, 200}
	
	set fpos to get bounds of wp7
	set fx to (item 1 of fpos) + (item 3 of fpos) div 2
	set fy to (item 2 of fpos) + (item 4 of fpos) div 2
end tell

activate application "Windows Phone 7 Connector"
tell application "System Events"
	repeat until front window of process "Windows Phone 7 Connector" exists
		delay 0.5
	end repeat
	repeat while title of front window of process "Windows Phone 7 Connector" contains "connect a device"
		delay 0.5
	end repeat
	
	tell front window of process "Windows Phone 7 Connector"
		keystroke (ASCII character 31)
		delay 0.5
		keystroke (ASCII character 9)
		keystroke (ASCII character 9)
		keystroke "a" using {command down}
	end tell
	
	set position of front window of process "Windows Phone 7 Connector" to {200, 0}
	set cpos to get position of scroll area 2 of splitter group 1 of front window of process "Windows Phone 7 Connector"
	set cx to (item 1 of cpos) + 100
	set cy to (item 2 of cpos) + 100
end tell

set clickdrag_script to (path to me as string) & "Contents:Resources:clickdrag.py"
do shell script "python " & (quoted form of POSIX path of clickdrag_script) & " " & cx & " " & cy & " " & fx & " " & fy

tell application "System Events"
	repeat while button "Cancel" of group 1 of splitter group 1 of front window of process "Windows Phone 7 Connector" exists
		delay 0.5
	end repeat
end tell

close wp7
quit application "Windows Phone 7 Connector"
do shell script "rsync -d '" & sync_folder_name & "/' '" & target_folder_name & "'"
do shell script "rm -r '" & sync_folder_name & "'"

activate
set answer to button returned of (display dialog "All done!" buttons {"Show contents in Finder", "OK"})

if answer is equal to "Show contents in Finder" then
	tell application "Finder"
		open (target_folder_name as POSIX file)
		activate
	end tell
end if
