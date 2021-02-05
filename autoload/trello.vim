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

  let cmd = g:command#GetBoardsCmd()

  try
    let result = json_decode(system(cmd))
  catch
    echomsg v:exception
    return
  endtry

  let boardDict = g:common#GetIdAndNameDictFromResList(result)
  let g:boardDictList = g:common#GetBoardDictListFromResList(result)

  call g:board#OpenBoardsNewBuffer(boardDict)

endfunction


" =================================
" for debug
"  - off comment out function-call below
"  - debug this script by `:so %`
" =================================
" call g:trello#VimTrello()
