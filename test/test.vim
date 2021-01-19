" ====================================
" execute `:so %` to start test-suite
" ====================================
function! s:test()
  " initialize v:error
  let v:errors = []

  " case1
  let l:test_line = "title(id)"
  let l:actual_id = g:common#GetIdFromLine(l:test_line)
  let l:actual_title = g:common#GetTitleFromLine(l:test_line)

  call assert_equal("id", l:actual_id)
  call assert_equal("title", l:actual_title)

  " case2
  let l:test_dict = {
    \ "id": "test_id",
    \ "name": "test_name",
    \ "dummy": "hoge"
    \ }
  let l:test_dict2 = {
    \ "id": "test_id2",
    \ "name": "test_name2"
    \ }
  let l:test_list = []
  call add(l:test_list, l:test_dict)
  call add(l:test_list, l:test_dict2)
  let l:actual_dict = g:common#GetIdAndNameDictFromResList(l:test_list)

  call assert_equal("test_name", l:actual_dict["test_id"])
  call assert_equal("test_name2", l:actual_dict["test_id2"])

  " case3
  let l:dict = {
    \ "id": "test_id",
    \ "name": "test_name",
    \ "desc": "hoge"
    \ }
  let actual_response = g:common#GetDescFromRes(l:dict)
  call assert_equal("hoge", l:actual_response)

  let l:dict2 = {
    \ "dummy": "fuga"
    \ }
  let actual_response = g:common#GetDescFromRes(l:dict2)
  call assert_equal("", l:actual_response)

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
