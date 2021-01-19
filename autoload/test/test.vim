" ====================================
" execute `:so %` to start test-suite
" ====================================
function! s:test()
  " initialize v:error
  let v:errors = []

  call g:test#common_test#TestCommon()

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
