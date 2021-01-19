function! g:test#common_test#TestCommon()
  call s:TestGetTitleFromLine()
  call s:TestGetIdFromLine()
  call s:TestGetIdAndNameDictFromResList()
  call s:TestGetDescFromRes()
endfunction


" CASE 1
function! s:TestGetIdFromLine()
  let l:test_line = "title(id)"
  let l:actual_id = g:common#GetIdFromLine(l:test_line)
  call assert_equal("id", l:actual_id)
endfunction

" CASE 2
function! s:TestGetTitleFromLine()
  let l:test_line = "title(id)"
  let l:actual_title = g:common#GetTitleFromLine(l:test_line)
  call assert_equal("title", l:actual_title)
endfunction

" CASE 3
function! s:TestGetIdAndNameDictFromResList()
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
endfunction

" CASE 4
function! s:TestGetDescFromRes()
  " with 'desc' key
  let l:dict = {
    \ "id": "test_id",
    \ "name": "test_name",
    \ "desc": "hoge"
    \ }
  let actual_response = g:common#GetDescFromRes(l:dict)
  call assert_equal("hoge", l:actual_response)

  " without 'desc' key
  let l:dict2 = {
    \ "dummy": "fuga"
    \ }
  let actual_response = g:common#GetDescFromRes(l:dict2)
  call assert_equal("", l:actual_response)
endfunction
