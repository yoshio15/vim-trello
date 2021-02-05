function! g:test#common_test#TestCommon()
  call s:TestGetTitleFromLine()
  call s:TestGetIdFromLine()
  call s:TestGetIdAndNameDictFromResList()
  call s:TestGetDescFromRes()
  call s:TestGetBoardDictListFromResList()
  call s:TestGetIdFromDictList()
  call s:TestGetNameByIdFromList()
endfunction


function! s:TestGetIdFromLine()
  let test_line = "title(id)"
  let actual_id = g:common#GetIdFromLine(test_line)
  call assert_equal("id", actual_id)
endfunction

function! s:TestGetTitleFromLine()
  let test_line1 = "1. title"
  let actual_title1 = g:common#GetTitleFromLine(test_line1)
  call assert_equal("title", actual_title1)

  let test_line2 = "10. title..."
  let actual_title2 = g:common#GetTitleFromLine(test_line2)
  call assert_equal("title...", actual_title2)
endfunction

function! s:TestGetIdAndNameDictFromResList()
  let test_dict = {
    \ "id": "test_id",
    \ "name": "test_name",
    \ "dummy": "hoge"
    \ }
  let test_dict2 = {
    \ "id": "test_id2",
    \ "name": "test_name2"
    \ }
  let test_list = []
  call add(test_list, test_dict)
  call add(test_list, test_dict2)
  let actual_dict = g:common#GetIdAndNameDictFromResList(test_list)

  call assert_equal("test_name", actual_dict["test_id"])
  call assert_equal("test_name2", actual_dict["test_id2"])
endfunction

function! s:TestGetDescFromRes()
  " with 'desc' key
  let dict = {
    \ "id": "test_id",
    \ "name": "test_name",
    \ "desc": "hoge"
    \ }
  let actual_response = g:common#GetDescFromRes(dict)
  call assert_equal("hoge", actual_response)

  " without 'desc' key
  let dict2 = {
    \ "dummy": "fuga"
    \ }
  let actual_response = g:common#GetDescFromRes(dict2)
  call assert_equal("", actual_response)
endfunction

function! s:TestGetBoardDictListFromResList()
  let responseList = [
        \ { "id" : "test-id1", "name": "test-name1" },
        \ { "id" : "test-id2", "name": "test-name2" },
        \ { "id" : "test-id3", "name": "test-name3" }
        \ ]
  let expected = [
        \ { "id": 1, "boardId" : "test-id1", "name": "test-name1" },
        \ { "id": 2, "boardId" : "test-id2", "name": "test-name2" },
        \ { "id": 3, "boardId" : "test-id3", "name": "test-name3" }
        \ ]
  let actual = g:common#GetBoardDictListFromResList(responseList)
  call assert_equal(expected, actual)
endfunction

function! s:TestGetIdFromDictList()
  let dictList = [
        \ { "id": 1, "boardId" : "test-id1", "name": "test-name1" },
        \ { "id": 2, "boardId" : "test-id2", "name": "test-name2" },
        \ { "id": 3, "boardId" : "test-id3", "name": "test-name3" }
        \ ]
  let actual1 = g:common#GetIdFromDictList(dictList, 1)
  let actual2 = g:common#GetIdFromDictList(dictList, 2)
  let actual3 = g:common#GetIdFromDictList(dictList, 3)
  let actual4 = g:common#GetIdFromDictList(dictList, 4)
  call assert_equal("test-id1", actual1)
  call assert_equal("test-id2", actual2)
  call assert_equal("test-id3", actual3)
  call assert_equal("", actual4)
endfunction

function! s:TestGetNameByIdFromList()
  let dictList = [
        \ { "id": 1, "boardId" : "test-id1", "name": "test-name1" },
        \ { "id": 2, "boardId" : "test-id2", "name": "test-name2" },
        \ { "id": 3, "boardId" : "test-id3", "name": "test-name3" }
        \ ]
  let actual1 = g:common#GetNameByIdFromList("test-id1", dictList)
  let actual2 = g:common#GetNameByIdFromList("test-id2", dictList)
  let actual3 = g:common#GetNameByIdFromList("test-id3", dictList)
  call assert_equal("test-name1", actual1)
  call assert_equal("test-name2", actual2)
  call assert_equal("test-name3", actual3)
endfunction
