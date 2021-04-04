function trishc -d 'Clear whole trashcan or sections of it'
	# Argument parsing
	argparse --exclusive h,a,o 'h/help' 'a/all' 'o#old' -- $argv

	# "HELP" ARGUMENT
	if set -q _flag_help
		return
	end

	# Locating the Trash folder
	if test -z "$XDG_DATA_HOME"
		set XDG_DATA_HOME ~/.local/share
	end
	set trash $XDG_DATA_HOME/Trash
	mkdir -p $trash/{files,info}

	# "ALL" ARGUMENT
	if set -q _flag_all
		read -P (set_color red ; echo -n 'Permanently remove all files? [y/n] ' ; set_color normal) confirmation
		switch $confirmation
			case y Y yes Yes YES
				rm -r $trash/{files,info}/*
			case n N no No NO
				echo 'Canceled'
			case '*'
				echo 'Invalid input'
		end
		return
	end

	# Defining the list of items in the trashcan
	set itemlist (command ls -a $trash/files)
	set -e itemlist[1 2] # remove '.' and '..' directories

	# "OLD" ARGUMENT
	if set -q _flag_old
		set count 0
		for item in $itemlist
			# Grep finds the proper line, string sub cuts out the 'DeletionDate=' tag and date command converts it to seconds since 1970-01-01
			set age (date -d (string sub -s 14 (grep --max-count=1 DeletionDate= $trash/info/$item.trashinfo)) +%s)
			set today (date +%s)
			set datediff (math \($today - $age\) / 86400)
			# If the item is $_flag_old days old or older, it gets deleted
			if test $datediff -ge $_flag_old
				rm -r $trash/files/$item
				rm -r $trash/info/$item.trashinfo
				set count (math $count + 1)
			end
		end
		printf "Deleted %i files that were %i days or more in the trash\n" $count $_flag_old
		return
	end

	# NO ARGUMENTS - INTERACTIVE CLEANING
	if test -z "$argv"
		# List contents of the trashcan
		trishl -l ; echo
		set_color blue ; echo "Delete which files? (e.g. '1 3 5..8')"
		read -a -P (set_color blue; echo -n ">> " ; set_color normal) dellist
		# resolving ranges
		for index in (seq (count $dellist)) # need to work with indexes to remove ranges from the list once resolved
			if string match --quiet "*..*" -- $dellist[$index]
				set range (string split --max 1 ".." -- $dellist[$index])
				set -a dellist (seq $range[1] $range[2] 2> /dev/null)
				if test ! $status -eq 0
					set_color red ; printf "'%s' not recognized\nRanges must have integers on both ends\n" $dellist[$index]
					return
				else if test $range[1] -gt $range[2]
					set_color red ; printf "Couldn't parse range '%s'\nIt seems the 1st number is greater than the 2nd\n" $dellist[$index]
					return
				end
				set -e dellist[$index]
			end
		end
		# looking for invalid values
		for item in $dellist
			test $item -ge 1 -a $item -le (count $itemlist) 2> /dev/null
			# if $item is out of range, test gives status 1. If it's not even a number, status 2.
			set indicator $status
			if test $indicator -eq 1 -a $item -le 0 2> /dev/null #don't want function to stop if $item can't be compared here
				set_color red ; printf "Invalid input '%s'\nUse only non-zero positive integers\n" $item
				return
			else if test $indicator -eq 1 -a $item -gt (count $itemlist) 2> /dev/null
				set_color red ; printf "Invalid index '%s'\nTrash currently has only %i files\n" $item (count $itemlist)
				return
			else if test $indicator -eq 2
				set_color red ; printf "Invalid input '%s'\nIndexes must be positive integers\n" $item
				return
			end
		end
		# deleting items
		set dellist (printf %i\n $dellist | sort -u)
		for index in (seq (count $itemlist))
			if string match --quiet "$index" $dellist
				rm -r $trash/info/$itemlist[$index].trashinfo
				rm -r $trash/files/$itemlist[$index]
				set -a deleted $itemlist[$index]
			end
		end
		set_color green ; echo -n "Deleted: " ; set_color normal ; printf "'%s' " $deleted
		echo
		return
	end
end
