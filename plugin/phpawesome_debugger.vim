function! phpawesome_debugger#runDebug() " {{{
    call StartPHPSleep()
    call vdebug#run()
endfunction "}}}

function! StartPHPSleep()
    call job_start('sleep 0.3', {'close_cb': 'StartPHPReal'})
endfunction

function! StartPHPReal(channel)
    let cmd ='php -dxdebug.remote_enable=1 ' . expand('%:p') 
    let $XDEBUG_CONFIG="idekey=xdebug"
    call job_start('php -dxdebug.remote_enable=1 ' . expand('%:p'), {'out_io': 'file', 'out_name': '/test.txt'})
endfunction

nnoremap <S-F9> :call phpawesome_debugger#runDebug()<CR>
