function trish -d 'Send files to the trashcan'
	# Argument parsing
	argparse 'h/help' -- $argv

	# "HELP" ARGUMENT
	if set -q _flag_help
		__trish_help trish
		return 0
	end
	
	# Variables common to all trish functions
	set trash (__trish_find_trash trash)
	set itemlist (__trish_find_trash itemlist)
	set trashcount (__trish_find_trash trashcount)

	# NO ARGUMENTS - Display basic usage
	if test -z "$argv"
		echo 'trish: expected at least one argument'
		echo 'see \'trish --help\' for more details'
	 	return
	end

    if test (count $argv) -eq (count command 'ls')
        set confirm (string lower (read -l -P 'Do you want to trash all the files in this folder? [y/N] '))

        if test $confirm = 'n'
            return 0
        end

        if test $confirm != 'y'
            echo 'trish: invalid option provided'
            return 0
        end
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
		mv $itempath $trash/files/$name 2> /dev/null
		if test $status -eq 1
			printf 'Error: %s doesn\'t exist\n' $itempath
		end
	end
end
