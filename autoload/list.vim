" =================================
" Lists
" =================================
function! g:list#OpenListsNewBuffer(listDict, boardId)

  let l:lists_buffer = 'LISTS'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(l:lists_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(add-list) :<C-u>call OpenAddNewListArea("' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(get-boards) :<C-u>call GetBoards()<CR>
  nnoremap <silent> <buffer> <Plug>(close-lists) :<C-u>bwipeout!<CR>
  exec 'nnoremap <silent> <buffer> <Plug>(open-lists) :<C-u>call GetCards(trim(getline(".")), "' . a:boardId . '")<CR>'
  nmap <buffer> a <Plug>(add-list)
  nmap <buffer> b <Plug>(get-boards)
  nmap <buffer> q <Plug>(close-lists)
  nmap <buffer> <CR> <Plug>(open-lists)

  let l:desc_a_key = '(a)dd new List'
  let l:desc_b_key = '(b)ack to boards'
  let l:desc_d_key = '(d)elete a List'
  let l:desc_q_key = '(q) close buffer'
  let l:desc_enter_key = '(Enter) show Tasks'

  call g:common#WriteDictToBuf(a:listDict)
  call append(0, '" select List below.')
  call append(0, '')
  call append(0, '')
  call append(0, l:desc_enter_key)
  call append(0, l:desc_q_key)
  call append(0, l:desc_b_key)
  call append(0, l:desc_a_key)

endfunction


function! OpenAddNewListArea(boardId)
  call inputsave()
  let l:userInput=input("Enter title of List which you want to add.\nnew List name: ")
  call inputrestore()

  call AddNewList(a:boardId, UrlEncode(l:userInput))
  call GetListsByBoardId(a:boardId)
endfunction


function! AddNewList(boardId, title)
  let l:cmd = g:command#AddNewListCmd(a:boardId, a:title)
  call system(l:cmd)
endfunction


" get Cards from Lists
function! GetCards(listName, boardId)
  if a:listName == ""
    return
  endif
  let l:listId = g:common#GetIdFromLine(a:listName)
  call GetCardsById(l:listId, a:boardId)
endfunction


function! GetCardsById(listId, boardId)
  let l:cmd = g:command#GetCardsCmd(a:listId)
  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry
  let l:listDict = g:common#GetIdAndNameDictFromResList(l:result)
  call g:task#OpenCardsNewBuffer(l:listDict, a:listId, a:boardId)
endfunction
