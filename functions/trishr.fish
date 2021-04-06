function trishr -d "Restore files from the trashcan"
	# Argument parsing
	argparse --exclusive h,a 'h/help' 'a/all' -- $argv

	# "HELP" ARGUMENT
	if set -q _flag_help
		__trish_help trishr
		return 0
	end
	
	# Variables common to all trish functions
	set trash (__trish_find_trash trash)
	set itemlist (__trish_find_trash itemlist)
	set trashcount (__trish_find_trash trashcount)

	# Empty trash
	if test $trashcount -eq 0
		set_color green ; echo 'Nothing to restore, trash is empty =)' ; set_color normal
		return 0
	end

	# "ALL" ARGUMENT
	if set -q _flag_all
		set_color blue ; printf '%i file(s) in trash. Restore? [y/n]\n' (count $itemlist) ; set_color normal
		read -P (set_color blue ; echo -n '>> ' ; set_color normal) confirm1
		echo
		switch $confirm1
			case y Y yes Yes YES
				for item in $itemlist
					set path (string unescape --style=url (string sub --start=6 (grep --max-count=1 Path= $trash/info/$item.trashinfo)))
					set path (string sub --length (math (string length $path) - (string length $item) -1) $path) # this is horrible. I have to update to fish 3.2 and eventually start using the new "--end" flag for string sub.
					if test -e $path/$item
						set_color red ; printf "%s/%s already exists. Overwrite? [y/n]\n" $path $item ; set_color normal
						read -P (set_color red ; echo -n '>> ' ; set_color normal) confirm2
						echo
						switch $confirm2
							case y Y yes Yes YES
								true
							case n N no No NO
								continue
							case '*'    
								echo 'Invalid input'
								break
						end
					end
					mkdir -p $path
					mv -f $trash/files/$item $path
					rm $trash/info/$item.trashinfo
					set -a restored $item
				end
				if set -q restored
					set_color green ; echo -n 'Restored: ' ; set_color normal
					printf '%s ' $restored ; echo
				end
			case n N no No NO
				echo 'Canceled'
			case '*'
				echo 'Invalid input'
		end
		return
	end

	# NO ARGUMENTS - Interactive restoring
	if test -z "$argv"
		# List contents of the trashcan
		trishl ; echo
		set_color blue ; echo "Which items restore?"
		read -a -P (set_color blue; echo -n ">> " ; set_color normal) restlist
		# resolving ranges
		for index in (seq (count $restlist)) # need to work with indexes to remove ranges from the list once resolved
			if string match --quiet "*..*" -- $restlist[$index]
				set range (string split --max 1 ".." -- $restlist[$index])
				set -a restlist (seq $range[1] $range[2] 2> /dev/null)
				if test ! $status -eq 0
					set_color red ; printf "'%s' not recognized\nRanges must have integers on both ends\n" $restlist[$index]
					return
				else if test $range[1] -gt $range[2]
					set_color red ; printf "Couldn't parse range '%s'\nIt seems the 1st number is greater than the 2nd\n" $restlist[$index]
					return
				end
				set -e restlist[$index]
			end
		end
		# looking for invalid values
		for item in $restlist
			test $item -ge 1 -a $item -le (count $itemlist) 2> /dev/null
			# if $item is out of range, test gives status 1. If it's not even a number, status 2.
			set indicator $status
			if test $indicator -eq 1 -a $item -le 0 2> /dev/null
				set_color red ; printf "Invalid input '%s'\nUse only non-zero positive integers\n" $item
				return
			else if test $indicator -eq 1 -a $item -gt (count $itemlist) 2> /dev/null
				set_color red ; printf "Invalid index '%s'\nTrash currently has only %i file(s)\n" $item (count $itemlist)
				return
			else if test $indicator -eq 2
				set_color red ; printf "Invalid input '%s'\nIndexes must be positive integers\n" $item
				return
			end
		end
		# restoring items
		for index in $restlist
			set path (string unescape --style=url (string sub --start=6 (grep --max-count=1 Path= $trash/info/$itemlist[$index].trashinfo)))
			set path (string sub --length (math (string length $path) - (string length $itemlist[$index]) -1) $path) # this is horrible. I have to update to fish 3.2 and eventually start using the new "--end" flag for string sub.
			if test -e $path/$itemlist[$index]
				set_color red ; printf "%s/%s already exists. Overwrite? [y/n]\n" $path $itemlist[$index] ; set_color normal
				read -P (set_color red ; echo -n '>> ' ; set_color normal) confirm3
				echo
				switch $confirm3
					case y Y yes Yes YES
						true
					case n N no No NO
						continue
					case '*'
						echo 'Invalid input'
						break
				end
			end
			mkdir -p $path
			mv -f $trash/files/$itemlist[$index] $path
			rm $trash/info/$itemlist[$index].trashinfo
			set -a restored $itemlist[$index]
		end
		if set -q restored
			set_color green ; echo -n 'Restored: ' ; set_color normal
			printf '%s ' $restored ; echo
		end
		return
	end
end
