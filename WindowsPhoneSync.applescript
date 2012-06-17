-- Windows Phone Sync applescript

-- initialize folder nameskd
set home_folder_name to (do shell script "echo ~")
set target_folder_name to home_folder_name & "/Windows Phone"
set sync_folder_name to home_folder_name & "/wp7-sync-temp"

-- Start sync
set answer to button returned of (display dialog "Preparing to sync your Windows Phone contents. Make sure that your phone is plugged in. Do not touch the computer until you see an \"All done\" dialog.\n\nSeriously, go make yourself some coffee or something. This may take several minutes." buttons {"Proceed", "Cancel"})

if answer is equal to "Cancel"
  exit
end if

-- Prepare folder structure
do shell script "mkdir -p '" & target_folder_name & "'"
do shell script "rm -rf '" & sync_folder_name & "'"
do shell script "mkdir -p '" & sync_folder_name & "'"


-- Set up finder window
tell application "Finder"
  -- open the sync folder in Finder
  activate
  set wp7 to make Finder window to (sync_folder_name as POSIX file)
  set the current view of wp7 to icon view
  set bounds of wp7 to {0, 0, 200, 200}
  -- calculate drop target
  set fpos to get bounds of wp7
  set fx to (item 1 of fpos) + (item 3 of fpos) div 2
  set fy to (item 2 of fpos) + (item 4 of fpos) div 2
end tell

-- Start Connector
quit application "Windows Phone 7 Connector"
activate application "Windows Phone 7 Connector"
tell application "System Events"
  -- Wait until Connector window appears
  repeat until front window of process "Windows Phone 7 Connector" exists
    delay 0.5
  end repeat

  -- Wait until Connector has found the phone
  -- TODO: have a timeout here so the script doesn't hang
  repeat while title of front window of process "Windows Phone 7 Connector" contains "connect a device"
    delay 0.5
  end repeat
  
  tell front window of process "Windows Phone 7 Connector"
    -- Down arrow - go to "Browse device"
    keystroke (ASCII character 31)
    delay 0.5
    -- Tab tab - go to the files table
    keystroke (ASCII character 9)
    keystroke (ASCII character 9)
    -- Cmd+A - select all files
    keystroke "a" using {command down}
  end tell

  -- calculate drag source
  set position of front window of process "Windows Phone 7 Connector" to {200, 0}
  set cpos to get position of scroll area 2 of splitter group 1 of front window of process "Windows Phone 7 Connector"
  set cx to (item 1 of cpos) + 100
  set cy to (item 2 of cpos) + 100
end tell

-- Perform drag-and-drop from Connector to Finder
set clickdrag_script to (path to me as string) & "Contents:Resources:clickdrag.py"
do shell script "python " & (quoted form of POSIX path of clickdrag_script) & " " & cx & " " & cy & " " & fx & " " & fy

-- Wait until copy is complete (and the Cancel button disappears)
tell application "System Events"
  repeat while button "Cancel" of group 1 of splitter group 1 of front window of process "Windows Phone 7 Connector" exists
    delay 0.5
  end repeat
end tell

-- Close windows
close wp7
quit application "Windows Phone 7 Connector"

-- Rsync from the temp directory to our target directory
do shell script "rsync -d '" & sync_folder_name & "/' '" & target_folder_name & "'"
do shell script "rm -r '" & sync_folder_name & "'"

-- Show success dialog
activate
set answer to button returned of (display dialog "Windows Phone sync done!" buttons {"Show sync results in Finder", "OK"})

if answer is equal to "Show contents in Finder" then
  tell application "Finder"
    open (target_folder_name as POSIX file)
    activate
  end tell
end if
