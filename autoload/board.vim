" =================================
" Board
" =================================
function! g:board#OpenBoardsNewBuffer(boardDict)

  let boards_buffer = 'BOARDS'
  call g:common#OpenNewBuf(boards_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer> <Plug>(close-boards) :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer> <Plug>(open-boards) :<C-u>call GetLists()<CR>
  nmap <buffer> q <Plug>(close-boards)
  nmap <buffer> <CR> <Plug>(open-boards)

  " let desc_a_key = '(a)dd new Board'
  " let desc_d_key = '(d)elete a Board'

  let explanations = [
        \ '(q) close buffer',
        \ '(Enter) show Board',
        \ '',
        \ 'select Board below.',
        \ ]
  call setbufline(boards_buffer, 1, explanations)
  call g:common#WriteDictListToBuf(g:boardDictList)

  call cursor(len(explanations)+2, 1)
  setlocal nomodifiable

endfunction


" get Boards from Lists
function! GetLists()
  let lineId = trim(getline('.'))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry

  let boardId = g:common#GetIdFromDictList(g:boardDictList, lineId)
  call GetListsByBoardId(boardId)
endfunction

function! s:CheckSelectedLine(char)
  let err_msg = "cannot select here."
  if a:char == ""
    throw err_msg
  endif
  for board in g:boardDictList
    if a:char == board.id
      return
    endif
  endfor
  throw err_msg
endfunction

function! GetListsByBoardId(boardId)
  let cmd = g:command#GetListsCmd(a:boardId)
  try
    let result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let listDict = g:common#GetIdAndNameDictFromResList(result)
  let g:listDictList = g:common#GetBoardDictListFromResList(result)
  call g:list#OpenListsNewBuffer(listDict, a:boardId)
endfunction


function! GetBoards()
  let cmd = g:command#GetBoardsCmd()
  try
    let result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let boardDict = g:common#GetIdAndNameDictFromResList(result)
  call g:common#CloseBuf()
  call g:board#OpenBoardsNewBuffer(boardDict)
endfunction
