function! g:trello#VimTrello()
  if !executable('curl')
    echo 'curl is not available'
    return
  endif
  let l:cmd = BuildCmd()
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  for board in l:result
    echomsg '=========================================='
    " echomsg board
    echomsg board['id']
    echomsg board['name']
  endfor
  call OpenNewBuffer()
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
  let l:cmd = "curl -s -X GET 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . '&token=' . g:vimTrelloToken . "'"
  return l:cmd
endfunction

" Boardリストを表示するバッファを生成する
let s:board_list_buffer = 'BOARDS'
function! OpenNewBuffer()
  execute 'vnew' s:board_list_buffer
endfunction

call g:trello#VimTrello()
