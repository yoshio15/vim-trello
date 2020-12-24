function! g:trello#VimTrello()
  if !executable('curl')
    echo 'curl is not available'
    return
  endif
  let l:cmd = BuildCmd()
  echomsg l:cmd
  let l:result = json_decode(system(cmd))
  let l:boardDict = {}
  for board in l:result
    :let l:boardDict[board['id']] = board['name']
  endfor
  call OpenNewBuffer(l:boardDict)
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
function! OpenNewBuffer(boardDict)
  execute 'vnew' s:board_list_buffer
  set buftype=nofile
  nnoremap <silent> <buffer>
    \ <Plug>(close-list)
    \ :<C-u>bwipeout!<CR>
  nmap <buffer> q <Plug>(close-list)
  echomsg keys(a:boardDict)
  call setline(1, values(a:boardDict))
endfunction

call g:trello#VimTrello()
