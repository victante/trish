function __trish_find_trash -a NAME -S
	# Locate the Trash folder
	if not set -q XDG_DATA_HOME
		set XDG_DATA_HOME ~/.local/share
	end
	set trash $XDG_DATA_HOME/Trash
	mkdir -p $trash/{files,info}

	# Define the list and quantity of items in the trashcan
	set itemlist (command ls -a $trash/files)
	set -e itemlist[1 2] # remove '.' and '..' directories
	set trashcount (count $itemlist)
	
	# Results
	switch $NAME
		case 'trash'
			echo $trash
		case 'itemlist'
			echo $itemlist
		case 'trashcount'
			echo $trashcount
	end
	return 0
end
