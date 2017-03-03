function! phpawesome_debugger#runDebug() " {{{
    call StartPHPSleep()
    call vdebug#run()
endfunction "}}}

function! StartPHPSleep()
    echom "Sleeping"
    call job_start('sleep 1', {'close_cb': 'StartPHPReal'})
endfunction

function! StartPHPReal(channel)
    let cmd ='php -dxdebug.remote_enable=1 ' . expand('%:p') 
    let $XDEBUG_CONFIG="idekey=xdebug"
    echom "Running PHP"
    call job_start('php -dxdebug.remote_enable=1 ' . expand('%:p'), {'out_io': 'file', 'out_name': '/test.txt'})
endfunction

nnoremap <S-F9> :call phpawesome_debugger#runDebug()<CR>
