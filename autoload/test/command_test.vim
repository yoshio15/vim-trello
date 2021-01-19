function! g:test#command_test#TestCommand()
  try
    call g:common#CheckEnv()
  catch
    echomsg v:exception
    return
  endtry

  call s:TestGetBoardsCmd()
  call s:TestGetListsCmd()
endfunction


function! s:TestGetBoardsCmd()
  let l:actual = g:command#GetBoardsCmd()
  let l:expected =  "curl -s --request GET --url 'https://api.trello.com/1/members/me/boards?key=" . g:vimTrelloApiKey . "&token=" . g:vimTrelloToken . "'"
  call assert_equal(l:expected, l:actual)
endfunction

function! s:TestGetListsCmd()
  let l:actual = g:command#GetListsCmd("testId")
  let l:expected =  "curl -s --request GET --url 'https://api.trello.com/1/boards/testId/lists?key=" . g:vimTrelloApiKey . "&token=" . g:vimTrelloToken . "'"
  call assert_equal(l:expected, l:actual)
endfunction
