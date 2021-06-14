function trish -d "Fish plugin to manage the trashcan"
    # No recognizable arguments

    switch $argv[1]
    # put
        case put
            __trish_put $argv[2..]
    # ls
        case ls
            __trish_ls $argv[2..]
    # show
        case show
            __trish_show $argv[2..]
    # restore
        case restore
            __trish_restore $argv[2..]
    # empty/rm
        case empty
            __trish_empty $argv[2..]
    end
end
