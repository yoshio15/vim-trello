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
  " TODO add edit description of task function
  " nmap <buffer> e <Plug>(edit-card)
  nmap <buffer> q <Plug>(close-buf)

  let desc_b_key = '(b)ack to Cards'
  let desc_q_key = '(q) close buffer'

  call setline(1, a:desc)
  call append(0, '----------------------------')
  call append(0, '" description of a Task.')
  call append(0, '')
  call append(0, '')
  call append(0, desc_q_key)
  call append(0, desc_b_key)

endfunction


function! EditCardDesc()
endfunction
