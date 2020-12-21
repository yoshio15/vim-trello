function! VimTrello()
  let l:cmd = BuildCmd()
  echomsg l:cmd
  let l:result = system(cmd)
  echomsg l:result
endfunction

function! BuildCmd()
  if !exists('g:vimTrelloApiKey')
    echo 'g:apiKey is not difined in your vimrc'
    return ""
  endif
  if !exists('g:vimTrelloToken')
    echo 'g:token is not difined in your vimrc'
    return ""
  endif
  let l:cmd = "curl 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
  return l:cmd
endfunction

command! Trello call VimTrello()
