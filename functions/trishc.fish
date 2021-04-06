function trishc -d 'Clean whole trashcan or sections of it'
	# Argument parsing
	argparse --exclusive h,a,o 'h/help' 'a/all' 'o#old!_validate_int --min 0' -- $argv

	# "HELP" ARGUMENT
	if set -q _flag_help
		__trish_help trishc
		return 0
	end

	# Variables common to all trish functions
	set trash (__trish_find_trash trash)
	set itemlist (__trish_find_trash itemlist)
	set trashcount (__trish_find_trash trashcount)

	# "ALL" ARGUMENT
	if set -q _flag_all
		set_color red ; printf '%i file(s) in trash. Delete? [y/n]\n' (count $itemlist) ; set_color normal
		read -P (set_color red ; echo -n '>> ' ; set_color normal) confirmation
		switch $confirmation
			case y Y yes Yes YES
				rm -rf $trash/{files,info}/*
				set_color green ; echo 'Done' ; set_color normal
			case n N no No NO
				echo 'Canceled'
			case '*'
				echo 'Invalid input'
		end
		return
	end

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
				rm -rf $trash/files/$item
				rm -r $trash/info/$item.trashinfo
				set count (math $count + 1)
			end
		end
		set_color green ; printf "Deleted %i items that were %i days or more in the trash\n" $count $_flag_old
		return
	end

	# NO ARGUMENTS - INTERACTIVE CLEANING
	if test -z "$argv"
		if test $trashcount -eq 0
			echo 'Trash is already empty =)'
			return
		end
		# List contents of the trashcan
		trishl ; echo
		set_color blue ; echo "Which items delete?"
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
			if test $indicator -eq 1 -a $item -le 0 2> /dev/null
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
				rm -rf $trash/files/$itemlist[$index]
				set -a deleted $itemlist[$index]
			end
		end
		set_color green ; echo -n "Deleted: " ; set_color normal ; printf "'%s' " $deleted
		echo
		return
	end
end
