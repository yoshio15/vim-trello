" ====================================
" execute `:so %` to start test-suite
" ====================================
function! s:test()
  " initialize v:error
  let v:errors = []

  let l:test_line = "title(id)"
  let l:actual_id = g:common#GetIdFromLine(l:test_line)
  let l:actual_title = g:common#GetTitleFromLine(l:test_line)

  call assert_equal("id", l:actual_id)
  call assert_equal("title", l:actual_title)

  call s:checkTestResult()
endfunction

function! s:checkTestResult()
  if len(v:errors) >= 1
    for err in v:errors
      echomsg err
    endfor
  else
    echomsg "all tests are passed."
  endif
endfunction

call s:test()
