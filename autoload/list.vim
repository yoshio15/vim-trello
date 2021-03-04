" List
" Author: ykondo
" License: MIT

function! g:list#OpenListsNewBuffer(boardId)

  let lists_buffer = 'LISTS'
  " set boardId to script local not to pass as args in many places.
  let s:boardId = a:boardId

  call g:common#CloseBuf()
  call g:common#OpenNewBuf(lists_buffer)

  set buftype=nofile
  nnoremap <silent> <buffer> <Plug>(add-list) :<C-u>call <SID>OpenAddNewListArea()<CR>
  nnoremap <silent> <buffer> <Plug>(get-boards) :<C-u>call <SID>GetBoards()<CR>
  nnoremap <silent> <buffer> <Plug>(delete-list) :<C-u>call <SID>DeleteList()<CR>
  nnoremap <silent> <buffer> <Plug>(close-lists) :<C-u>bwipeout!<CR>
  nnoremap <silent> <buffer> <Plug>(open-lists) :<C-u>call <SID>GetCards()<CR>
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

function! s:OpenAddNewListArea()
  call inputsave()
  let userInput=input("Enter title of List which you want to add.\nnew List name: ")
  call inputrestore()

  if trim(userInput) == ''
    return
  endif

  call s:AddNewList(UrlEncode(userInput))
  call board#GetListsByBoardId(s:boardId)
endfunction

function! s:AddNewList(title)
  let path = "/1/lists"
  let url = printf('%s&idBoard=%s&name=%s', common#BuildTrelloApiUrl(path), s:boardId, a:title)
  call http#Post(url)
endfunction

function! s:DeleteList()
  let listName = trim(getline("."))
  let lineId = trim(getline("."))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry

  call inputsave()
  let userInput=input(printf("Are you sure to delete the list:\n%s(yN): ", listName))
  call inputrestore()

  if userInput ==? "y"
    let listId = g:common#GetIdFromDictList(g:listDictList, lineId)
    let path = printf("/1/lists/%s/closed", listId)
    let url = printf('%s&value=true', common#BuildTrelloApiUrl(path))
    call http#Put(url)
    call board#GetListsByBoardId(s:boardId)
  else
    echomsg "not deleted list."
  endif
endfunction

function! s:GetCards()
  let lineId = trim(getline("."))[0]
  try
    call s:CheckSelectedLine(lineId)
  catch
    echomsg v:exception
    return
  endtry
  let listId = g:common#GetIdFromDictList(g:listDictList, lineId)
  call list#GetCardsById(listId, s:boardId)
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
