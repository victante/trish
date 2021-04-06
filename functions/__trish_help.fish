function __trish_help -a NAME
	switch $NAME
		case trish
			echo -e '\ntrish - send files/directories to the trashcan\n'
			echo -e '\ttrish ITEMS\n'
			set_color -o ; echo -ne 'DESCRIPTION\ntrish ' ; set_color normal
			echo -ne 'sends files and directories to the user\'s trashcan.\n\n' ; set_color -o ; echo -ne 'ITEMS ' ; set_color normal ; echo -ne 'can be the paths to any files or directories in your home partition, or simply their names (provided they\'re in the current working directory).\n\n' ; set_color -o ; echo -ne 'trish ' ; set_color normal ; echo -ne 'tries to be compliant with the FreeDesktop.org specification for the Trash. This means, among other stuff, that trashed ' ; set_color -o ; echo -ne 'ITEMS ' ; set_color normal ; echo -ne 'are sent to $XDG_DATA_HOME/Trash, which, if not set, defaults to ~/.local/share/Trash - if your distro/file manager implements this specification, it should be interoperable with trish.\n\n'
			set_color -o ; echo 'EXAMPLES' ; set_color normal
			echo -e '\t# Trashes the \'foo\' directory.\n\ttrish foo\n'
			echo -e '\t# Trashes both \'foo\' directory and \'bar.txt\' file.\n\ttrish foo bar.txt\n'
			echo -e '\t# Trashes everything in the current directory.\n\ttrish *\n'
			echo -e '\t# Trashes the file whose name is stored in $file.\n\ttrish $file\n'
			set_color -o ; echo 'NOTE' ; set_color normal
			echo 'The FreeDesktop.org Trash spec can be found here: https://specifications.freedesktop.org/trash-spec/trashspec-latest.html'
		case trishc
			echo -e '\ntrishc - clean the trashcan\n'
			echo -e '\ttrishc\n\ttrishc [-a/--all]\n\ttrishc [-o INT/--old INT/-INT]\n'
			set_color -o ; echo 'DESCRIPTION' ; set_color normal
			set_color -o ; echo -ne 'trishc ' ; set_color normal ; echo -ne 'can be used to either (1) select which files/directories to clean; (2) clean your entire trash folder at once; or (3) clean only files/directories that were trashed ' ; set_color -o ; echo -ne 'INT ' ; set_color normal ; echo -ne 'days ago or more.\n\n'
			set_color -o ; echo 'USAGE' ; set_color normal
			echo -ne '\tIf called with no arguments, ' ; set_color -o ; echo -ne 'trishc ' ; set_color normal ; echo -ne 'enters interactive mode: trash contents are listed and the user selects which items to delete by typing their respective indexes. Valid input are individual integers separated by spaces. Ranges are also suported using the notation \'X..Y\'.\n\n'
			set_color -o ; echo -ne '\t-a / --all ' ; set_color normal ; echo -ne 'cleans the entire trash folder.\n\n'
			set_color -o ; echo -ne '\t-o INT / --old INT / -INT ' ; set_color normal ; echo -ne 'permanently removes items that were in the trash for INT days or more.\n\n'
			set_color -o ; echo -e 'EXAMPLES' ; set_color normal
			echo -e '\t# Cleans files indexed at 1, 3, 4 and 5.\n\n\t$ trishc\n'
			echo -e '\tIndex  Name'
			printf '\t[%i]    file%i.txt\n' 1 1 2 2 3 3 4 4 5 5
			echo -e '\tWhich items delete?'
			echo -e '\t>> 1 3..5'
			echo -e '\n\tDeleted: file1.txt file3.txt file4.txt file5.txt\n'
			echo -e '\t# Cleans the entire trash folder.\n\ttrishc -a\n\ttrishc --all\n'
			echo -e '\t# Removes items that were in the trash for 10 days or more.\n\ttrishc -o 10\n\ttrishc --old 10\n\ttrishc -10'
		case trishl
			echo -e '\ntrishl - list what\'s in the trash folder\n'
			echo -e '\ttrishl\n\ttrishl [-p INT/--peek INT/-INT]\n'
			set_color -o ; echo -ne 'DESCRIPTION\ntrishl ' ; set_color normal
			echo -ne 'has two use cases: (1) list what\'s in the trash folder; and (2) "peek" inside a deleted folder, which helps identify if it contains something important.\n\n'
			set_color -o ; echo 'USAGE' ; set_color normal
			echo -ne '\tIf called with no arguments, ' ; set_color -o ; echo -ne 'trishl ' ; set_color normal ; echo -ne 'lists the contents of the trash folder in a nice table containing their Index, Type (directory or file), Name and Original Path.\n\n'
			set_color -o ; echo -ne '\t-p INT / --peek INT / -INT ' ; set_color normal ; echo -ne 'lists what\'s inside the folder of index '; set_color -o ; echo -ne 'INT.\n\n' ; set_color normal
			set_color -o ; echo 'EXAMPLES' ; set_color normal
			echo -e '\t# Lists everything in the trash folder.\n\ttrishl\n'
			echo -e '\t# "Peek" inside the folder of index 42.\n\ttrishl -p 42\n\ttrishl --peek 42\n\ttrishl -42'
		case trishr
			echo -e '\ntrishr - restore files from the trash folder'
			echo -e '\ttrishr\n\ttrishr [-a/--all]\n'
			set_color -o ; echo -ne 'DESCRIPTION\ntrishr ' ; set_color normal
			echo -e 'can be used to either (1) select which files/directories to restore; or (2) restore everything from the trash folder at once.\n'
			set_color -o ; echo 'USAGE' ; set_color normal
			echo -ne '\tIf called with no arguments, ' ; set_color -o ; echo -ne 'trishr ' ; set_color normal ; echo -ne 'enters interactive mode: trash contents are listed and the user selects which items to restore by typing their respective indexes. Valid input are individual integers separated by spaces. Ranges are also suported using the notation \'X..Y\'\n\n'
			set_color -o ; echo -ne '\t-a / --all ' ; set_color normal ; echo -ne 'restores all items from the trash to their respective original paths.\n\n'
			set_color -o ; echo 'EXAMPLES' ; set_color normal
			echo -e '\t# Restores files indexed at 1, 3, 4 and 5.\n\n\t$ trishr\n'
			echo -e '\tIndex  Name'
			printf '\t[%i]    file%i.txt\n' 1 1 2 2 3 3 4 4 5 5
			echo -e '\tWhich items restore?'
			echo -e '\t>> 1 3..5'
			echo -e '\n\tRestored: file1.txt file3.txt file4.txt file5.txt\n'
			echo -e '\t# Restore everything from the trash folder.\n\ttrishr -a\n\ttrishr --all'
	end
	return 0
end
