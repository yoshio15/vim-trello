" =================================
" 【Main】vim-trello
" =================================
let g:boardDictList = []
let g:listDictList = []
let g:taskDictList = []

function! g:trello#VimTrello()

  try
    call g:common#CheckEnv()
  catch
    echomsg v:exception
    return
  endtry

  let l:cmd = g:command#GetBoardsCmd()

  try
    let l:result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let l:boardDict = g:common#GetIdAndNameDictFromResList(l:result)
  let g:boardDictList = g:common#GetBoardDictListFromResList(l:result)

  call g:board#OpenBoardsNewBuffer(l:boardDict)

endfunction


" =================================
" for debug
"  - off comment out function-call below
"  - debug this script by `:so %`
" =================================
" call g:trello#VimTrello()
