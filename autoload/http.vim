" HTTP
" Author: ykondo
" License: MIT

let s:HTTP = vital#vim_trello#import('Web.HTTP')

function! http#Get(url, ...) abort
  let settings = {
  \    'url': a:url,
  \    'param': a:0 > 0 ? a:1 : {},
  \    'headers': a:0 > 1 ? a:2 : {},
  \ }
  return s:HTTP.request(settings)
endfunction

function! http#Post(url, ...) abort
  let settings = {
  \    'url': a:url,
  \    'data': a:0 > 0 ? a:1 : {},
  \    'headers': a:0 > 1 ? a:2 : {},
  \    'method': a:0 > 2 ? a:3 : 'POST',
  \ }
  return s:HTTP.request(settings)
endfunction
