function! g:test#curl_test#TestCurl()
  call s:TestCurlGetCmd()
  call s:TestCurlPostCmd()
  call s:TestCurlPutCmd()
  call s:TestCurlDeleteCmd()
endfunction

let s:url = "https://example.com"

function! s:TestCurlGetCmd()
  let actual_cmd = g:curl#CurlGetCmd(s:url)
  let expected_cmd = "curl -s --request GET --url 'https://example.com'"
  call assert_equal(expected_cmd, actual_cmd)
endfunction

function! s:TestCurlPostCmd()
  let actual_cmd = g:curl#CurlPostCmd(s:url)
  let expected_cmd = "curl -s --request POST --url 'https://example.com'"
  call assert_equal(expected_cmd, actual_cmd)
endfunction

function! s:TestCurlPutCmd()
  let actual_cmd = g:curl#CurlPutCmd(s:url)
  let expected_cmd = "curl -s --request PUT --url 'https://example.com'"
  call assert_equal(expected_cmd, actual_cmd)
endfunction

function! s:TestCurlDeleteCmd()
  let actual_cmd = g:curl#CurlDeleteCmd(s:url)
  let expected_cmd = "curl -s --request DELETE --url 'https://example.com'"
  call assert_equal(expected_cmd, actual_cmd)
endfunction
