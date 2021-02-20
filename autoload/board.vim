" =================================
" Board
" =================================
function! g:board#OpenBoardsNewBuffer()

  let boards_buffer = 'BOARDS'
  call g:common#OpenNewBuf(boards_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer> <Plug>(close-boards) :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer> <Plug>(open-boards) :<C-u>call <SID>GetLists()<CR>
  nmap <buffer> q <Plug>(close-boards)
  nmap <buffer> <CR> <Plug>(open-boards)

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

function! board#SetBoardList() abort
  let path = "/1/members/me/boards"
  let url = common#BuildTrelloApiUrl(path)
  let response = http#Get(url)

  if response['status'] == 200
    try
      let result = json_decode(response['content'])
    catch
      throw v:exception
    endtry
    " set board list to global
    let g:boardDictList = g:common#GetBoardDictListFromResList(result)
    return
  endif

  throw response['content']
endfunction

function! s:GetLists()
  let lineId = trim(getline('.'))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry

  let boardId = g:common#GetIdFromDictList(g:boardDictList, lineId)
  call board#GetListsByBoardId(boardId)
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

function! board#GetListsByBoardId(boardId)
  call list#SetList(a:boardId)
  call g:list#OpenListsNewBuffer(a:boardId)
endfunction
