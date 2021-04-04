function trish -d 'Send files to the trashcan'
	# Argument parsing
	argparse 'h/help' -- $argv

	# "HELP" ARGUMENT
	if set -q _flag_help
		#display help
		return
	end
	
	# Locating the Trash folder
	if test -z "$XDG_DATA_HOME"
		set XDG_DATA_HOME ~/.local/share
	end
	set trash $XDG_DATA_HOME/Trash
	mkdir -p $trash/{files,info}

	# NO ARGUMENTS - Same as trishl
	if test -z "$argv"
		trishl
		return
	end

	# WITH ARGUMENTS TO BE SENT TO TRASH
	for item in $argv
		# each item being trashed is tested against the contents of the trashcan
		set itempath (realpath --no-symlinks $item)
		set name (basename $itempath)
		set index 0
		# if there's an item in the trashcan with the same name, the new one will receive a unique name based on $index
		while true
			if test ! -e $trash/files/$name # when the assigned $name becomes unique, breaks out of loop
				break
			else
				set index (math $index + 1)
				# if $name has 1+ dot(s), $index must be placed after the first dot
				set splitname $index (string split -m1 . (basename $itempath))
				set splitname[1 2] $splitname[2] $splitname[1]
				set name (string join . $splitname)
			end
		end
		# create the .trashinfo file
		set infofile $trash/info/$name.trashinfo
		echo -e [Trash Info]\nPath=(string escape --no-quoted --style=url $itempath)\nDeletionDate=(date +%FT%T) > $infofile

		# finally, move the specified item to the trashcan
		mv $itempath $trash/files/$name
	end
end
