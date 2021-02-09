" =================================
" Detail of a Task
" =================================
function! g:task_detail#OpenSingleCardNewBuffer(desc, listId, boardId)

  if a:desc == ""
    return
  endif

  let single_card_buffer = 'CARD'
  call g:common#CloseBuf()
  call g:common#OpenNewBuf(single_card_buffer)

  set buftype=nofile
  exec 'nnoremap <silent> <buffer> <Plug>(get-cards) :<C-u>call GetCardsById("' . a:listId . '", "' . a:boardId . '")<CR>'
  nnoremap <silent> <buffer> <Plug>(close-buf) :<C-u>bwipeout!<CR>
  nmap <buffer> b <Plug>(get-cards)
  nmap <buffer> q <Plug>(close-buf)

  let desc_b_key = '(b)ack to Cards'
  let desc_q_key = '(q) close buffer'

  let explanations = [
        \ '(b)ack to Cards',
        \ '(q) close buffer',
        \ '',
        \ 'Description of a Task',
        \ '----------------------------------------------'
        \ ]
  call setbufline(single_card_buffer, 1, explanations)
  call append("$", a:desc)

  call cursor(len(explanations)+1, 1)
endfunction


function! EditCardDesc()
endfunction
