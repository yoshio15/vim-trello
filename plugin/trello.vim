function! VimTrello()
  " curl 'https://api.trello.com/1/members/me/boards?key={yourKey}&token={yourToken}'
  " Todo Trello API call
  let l:cmd = 'curl https://www.google.com'
  let l:result = system(cmd)
  echomsg l:result
endfunction

command! Trello call VimTrello()

call VimTrello()
