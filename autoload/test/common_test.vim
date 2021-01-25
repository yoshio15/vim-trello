function! g:test#common_test#TestCommon()
  call s:TestGetTitleFromLine()
  call s:TestGetIdFromLine()
  call s:TestGetIdAndNameDictFromResList()
  call s:TestGetDescFromRes()
  call s:TestGetBoardDictListFromResList()
  call s:TestGetIdFromDictList()
endfunction


function! s:TestGetIdFromLine()
  let l:test_line = "title(id)"
  let l:actual_id = g:common#GetIdFromLine(l:test_line)
  call assert_equal("id", l:actual_id)
endfunction

function! s:TestGetTitleFromLine()
  let l:test_line1 = "1. title"
  let l:actual_title1 = g:common#GetTitleFromLine(l:test_line1)
  call assert_equal("title", l:actual_title1)

  let l:test_line2 = "10. title..."
  let l:actual_title2 = g:common#GetTitleFromLine(l:test_line2)
  call assert_equal("title...", l:actual_title2)
endfunction

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

function! s:TestGetBoardDictListFromResList()
  let l:responseList = [
        \ { "id" : "test-id1", "name": "test-name1" },
        \ { "id" : "test-id2", "name": "test-name2" },
        \ { "id" : "test-id3", "name": "test-name3" }
        \ ]
  let l:expected = [
        \ { "id": 1, "boardId" : "test-id1", "name": "test-name1" },
        \ { "id": 2, "boardId" : "test-id2", "name": "test-name2" },
        \ { "id": 3, "boardId" : "test-id3", "name": "test-name3" }
        \ ]
  let l:actual = g:common#GetBoardDictListFromResList(responseList)
  call assert_equal(l:expected, l:actual)
endfunction

function! s:TestGetIdFromDictList()
  let l:dictList = [
        \ { "id": 1, "boardId" : "test-id1", "name": "test-name1" },
        \ { "id": 2, "boardId" : "test-id2", "name": "test-name2" },
        \ { "id": 3, "boardId" : "test-id3", "name": "test-name3" }
        \ ]
  let l:actual1 = g:common#GetIdFromDictList(l:dictList, 1)
  let l:actual2 = g:common#GetIdFromDictList(l:dictList, 2)
  let l:actual3 = g:common#GetIdFromDictList(l:dictList, 3)
  let l:actual4 = g:common#GetIdFromDictList(l:dictList, 4)
  call assert_equal("test-id1", l:actual1)
  call assert_equal("test-id2", l:actual2)
  call assert_equal("test-id3", l:actual3)
  call assert_equal("", l:actual4)
endfunction
