function trishl -d 'List the contents of the trashcan'
	# Argument parsing
	argparse --exclusive h,p,l 'h/help' 'p/peek=' 'l/long' -- $argv
	
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
	
	# Defining the list of items in the trashcan
	set itemlist (command ls -a $trash/files)
	set -e itemlist[1 2] # remove '.' and '..' directories

	# "PEEK" ARGUMENT - print the contents of a specified directory in the trashcan
	if set -q _flag_peek
		command ls -a $trash/files/$itemlist[$_flag_peek]
		return
	end

	# "LONG" ARGUMENT - print a table with index, type (file or dir), name of the file and original path
	if set -q _flag_long
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

	# NO ARGUMENTS - print a simple list containing an index number and the name of the item on the trashcan
	if test -z "$argv"
		for index in (seq (count $itemlist))
			set -a list (string join '\t' [$index] $itemlist[$index]'\n')
		end
		string trim (echo -e $list) | column -t -s (printf \t)
	end
end

