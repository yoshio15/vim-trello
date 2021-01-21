" =================================
" Board
" =================================
function! g:board#OpenBoardsNewBuffer(boardDict, boardDictList)

  let l:boards_buffer = 'BOARDS'
  call g:common#OpenNewBuf(l:boards_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer> <Plug>(close-boards) :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer> <Plug>(open-boards) :<C-u>call GetLists(trim(getline('.')))<CR>
  nmap <buffer> q <Plug>(close-boards)
  nmap <buffer> <CR> <Plug>(open-boards)

  let l:desc_a_key = '(a)dd new Board'
  let l:desc_d_key = '(d)elete a Board'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show Board'


  " call g:common#WriteDictListToBuf(a:boardDictList)

  call g:common#WriteDictToBuf(a:boardDict)
  call append(0, '" select Board below.')
  call append(0, '')
  call append(0, '')
  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)

endfunction


" get Boards from Lists
function! GetLists(boardName)

  if a:boardName == ""
    return
  endif

  let l:boardId = g:common#GetIdFromLine(a:boardName)
  call GetListsByBoardId(l:boardId)

endfunction

function! GetListsByBoardId(boardId)
  let l:cmd = g:command#GetListsCmd(a:boardId)
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call g:list#OpenListsNewBuffer(l:listDict, a:boardId)
endfunction


function! GetBoards()
  let l:cmd = g:command#GetBoardsCmd()
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:boardDict = g:common#GetIdAndNameDictFromResList(l:result)
  call g:common#CloseBuf()
  call g:board#OpenBoardsNewBuffer(l:boardDict)
endfunction
