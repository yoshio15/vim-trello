function! VimTrello()
  let l:cmd = BuildCmd()
  echomsg l:cmd
  let l:result = system(cmd)
  echomsg l:result
endfunction

function! BuildCmd()
  if !exists('g:apiKey')
    echo 'g:apiKey is not difined in your vimrc'
    finish
  endif
  if !exists('g:token')
    echo 'g:token is not difined in your vimrc'
    finish
  endif
  let l:cmd = "curl 'https://api.trello.com/1/members/me/boards?key=" . g:apiKey . '&token=' . g:token . "'"
  return l:cmd
endfunction

command! Trello call VimTrello()

call VimTrello()
