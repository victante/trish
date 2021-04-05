function trishl -d 'List the contents of the trashcan'
	# Argument parsing
	argparse --exclusive h,p 'h/help' 'p/peek=' -- $argv
	
	# "HELP" ARGUMENT
	if set -q _flag_help
		__trish_help trishl
		return 0
	end

	# Variables common to all trish functions
	set common (__trish_find_trash) ; set trash $common[1] ; set itemlist $common[2]

	# "PEEK" ARGUMENT - print the contents of a specified directory in the trashcan
	if set -q _flag_peek
		command ls -a $trash/files/$itemlist[$_flag_peek]
		return
	end

	# NO ARGUMENTS - list the contents of the trashcan
	if test -z "$argv"
		for index in (seq (count $itemlist))
			if test -d $trash/files/$itemlist[$index]
				set type dir
			else
				set type file
		end
			# Grep finds the path, string sub cuts out the 'Path=' and string unescape translates back from url style
			set path (string unescape --style=url (string sub -s 6 (grep --max-count=1 Path= $trash/info/$itemlist[$index].trashinfo)))
			# Everything is put together as an element in the list 'table'. The \t separator will be used by column command.
			set -a table (string join '\t' [$index] $type $itemlist[$index] $path'\n')
		end
		string trim (echo -e $table) | column -t -s (printf \t) -N Index,Type,Name,'Original Path'
		return
	end
end

