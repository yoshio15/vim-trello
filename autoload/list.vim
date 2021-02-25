" List
" Author: ykondo
" License: MIT

function! g:list#OpenListsNewBuffer(boardId)

  let lists_buffer = 'LISTS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(lists_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(add-list) :<C-u>call <SID>OpenAddNewListArea("' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(get-boards) :<C-u>call <SID>GetBoards()<CR>
  exec 'nnoremap <silent> <buffer> <Plug>(delete-list) :<C-u>call <SID>DeleteList(trim(getline(".")), "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-lists) :<C-u>bwipeout!<CR>
  exec 'nnoremap <silent> <buffer> <Plug>(open-lists) :<C-u>call <SID>GetCards("' . a:boardId . '")<CR>'
  nmap <buffer> a <Plug>(add-list)
  nmap <buffer> b <Plug>(get-boards)
  nmap <buffer> d <Plug>(delete-list)
  nmap <buffer> q <Plug>(close-lists)
  nmap <buffer> <CR> <Plug>(open-lists)

  let board_name = g:common#GetNameByIdFromList(a:boardId, g:boardDictList)
  let explanations = [
        \ '(a)dd new List',
        \ '(b)ack to Boards',
        \ '(d)elete a List',
        \ '(q) close buffer',
        \ '(Enter) show Tasks',
        \ '',
        \ printf('Board: %s', board_name)
        \ ]
  call setbufline(lists_buffer, 1, explanations)
  call g:common#WriteDictListToBuf(g:listDictList)

  call cursor(len(explanations)+2, 1)
  setlocal nomodifiable

endfunction

function! s:GetBoards()
  call board#SetBoardList()
  call g:common#CloseBuf()
  call g:board#OpenBoardsNewBuffer()
endfunction

function! list#SetList(boardId) abort
  let path = printf("/1/boards/%s/lists", a:boardId)
  let url = common#BuildTrelloApiUrl(path)
  let response = http#Get(url)

  if response['status'] == 200
    try
      let result = json_decode(response['content'])
    catch
      throw v:exception
    endtry
    " set list to global
    let g:listDictList = g:common#GetBoardDictListFromResList(result)
    return
  endif

  throw response['content']
endfunction

function! s:OpenAddNewListArea(boardId)
  call inputsave()
  let userInput=input("Enter title of List which you want to add.\nnew List name: ")
  call inputrestore()

  if trim(userInput) == ''
    return
  endif

  call s:AddNewList(a:boardId, UrlEncode(userInput))
  call board#GetListsByBoardId(a:boardId)
endfunction

function! s:AddNewList(boardId, title)
  let cmd = g:command#AddNewListCmd(a:boardId, a:title)
  call system(cmd)
endfunction

function! s:DeleteList(listName, boardId)
  let lineId = trim(getline("."))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry

  call inputsave()
  let userInput=input(printf("Are you sure to delete the list:\n%s(yN): ", a:listName))
  call inputrestore()

  if userInput ==? "y"
    let listId = g:common#GetIdFromDictList(g:listDictList, lineId)
    let cmd = g:command#DeleteListCmd(listId)
    call system(cmd)
    call board#GetListsByBoardId(a:boardId)
  else
    echomsg "not deleted list."
  endif
endfunction

function! s:GetCards(boardId)
  let lineId = trim(getline("."))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry
  let listId = g:common#GetIdFromDictList(g:listDictList, lineId)
  call list#GetCardsById(listId, a:boardId)
endfunction

function! s:CheckSelectedLine(char)
  let err_msg = "cannot select here."
  if a:char == ""
    throw err_msg
  endif
  for _list in g:listDictList
    if a:char == _list.id
      return
    endif
  endfor
  throw err_msg
endfunction

function! list#GetCardsById(listId, boardId)
  call task#SetTaskList(a:listId)
  call g:task#OpenCardsNewBuffer(a:listId, a:boardId)
endfunction
