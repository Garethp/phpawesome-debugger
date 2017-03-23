function! phpawesome_debugger#runDebug() " {{{
    call StartPHPSleep()
    call vdebug#run()
endfunction "}}}

function! StartPHPSleep()
    call job_start('sleep 0.3', {'close_cb': 'StartPHPReal'})
endfunction

function! StartPHPReal(channel)
    let runner = "local"
    if runner == "vagrant"
        let runCommand = GetVagrantPhpRunCommand()
        if runCommand == '0'
            let runner = "local"
        endif
    endif

    if runner == "local"
        let runCommand = GetLocalPhpRunCommand()
    endif

    let $XDEBUG_CONFIG="idekey=xdebug"
    echo runCommand

    call job_start(runCommand, {'out_io': 'file', 'out_name': '/test.txt'})
endfunction

nnoremap <S-F9> :call phpawesome_debugger#runDebug()<CR>

function! GetLocalPhpRunCommand()
    let phpExecutable = '/usr/bin/env php'
    return phpExecutable . ' -dxdebug.remote_enable=1 ' . expand('%:p')
endfunction

function! GetVagrantPhpRunCommand()
    " TODO: Make this configurable per-project
    let directoryMappings = { }
    let currentDirectory = getcwd()
    let vagrantFile = 0

    for localDirectory in keys(directoryMappings)
        if currentDirectory =~ localDirectory
            let vagrantFile = substitute(expand('%:p'), localDirectory, directoryMappings[localDirectory], "")
        endif
    endfor

    if vagrantFile == '0'
        echom vagrantFile
        return 0
    endif

    echo 'vagrant'
    return 'vagrant ssh -c "/usr/bin/env php -dxdebug.remote_enable=1 ' . vagrantFile . '"'
endfunction
