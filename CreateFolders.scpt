(*
Creates folders for a split job ticket.
*)

-- get the path to the folder of the front window
-- if no windows are open, the desktop folder will be used
try
	tell application "Finder" to set the source_folder to (folder of the front window) as alias
	on error -- no open folder windows
		set the source_folder to path to desktop folder as alias
	end tell
end try

repeat
	display dialog "Enter Job Number:" default answer "" buttons {"Cancel", "OK"} default button 2
	set the job_number to the text returned of the result
	if the job_number is not "" then exit repeat
end repeat

repeat
	display dialog "Enter Customer:" default answer "" buttons {"Cancel", "OK"} default button 2
	set the customer_name to the text returned of the result
	if the customer_name is not "" then exit repeat
end repeat

repeat
	display dialog "Enter Number of Parts:" default answer "1" buttons {"Cancel", "OK"} default button 2
	set job_parts to (the text returned of the result) as integer
	if class of job_parts is integer then exit repeat
end repeat

-- Add subfolders to a given parent folder
on addFolders(pf)
	tell application "Finder"
		make new folder at pf with properties {name:"PRINT"}
		make new folder at pf with properties {name:"Preflight Reports"}
		make new folder at pf with properties {name:"Source Files"}
	end tell
end addFolders

tell application "Finder"
	set parentFolder to make new folder at source_folder with properties {name:job_number & "." & customer_name}
	
	if job_parts > 1 then
		repeat with i from 0 to (job_parts - 1)
			set suffix to ""
			if i > 0 then
				set suffix to "."
				if i < 10 then
					set suffix to suffix & "0"
				end if
				set suffix to suffix & i
			end if
			
			set newFolder to make new folder at parentFolder with properties {name:job_number & suffix}
			my addFolders(newFolder)
		end repeat
	else
		my addFolders(parentFolder)
	end if
	beep 2
end tell
