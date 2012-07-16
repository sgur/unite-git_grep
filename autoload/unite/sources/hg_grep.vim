"=============================================================================
" FILE: hg_grep.vim
" Last Modified: 29 Jun 2011.
" Description: A source that invokes 'hg grep -n .' from :Unite
" Usage: :Unite hg_grep<Return>
" Notes:
"=============================================================================
function! unite#sources#hg_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'vcs_grep/hg',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 30,
			\ 'required_pattern_length': 3,
			\ 'hooks'    : {},
			\ }

function! s:source.hooks.on_init(args, context)"{{{
	if !unite#sources#hg_grep#check()
		call unite#util#print_error('Not a Mercurial repoitory.')
	endif
endfunction"}}}

function! s:source.change_candidates(args, context)"{{{
	return unite#sources#hg_grep#grep(a:context.input)
endfunction"}}}

function! unite#sources#hg_grep#check()"{{{
	call unite#util#system('hg root')
	return (unite#util#get_last_status() == 0)? 1 : 0
endfunction"}}}

function! unite#sources#hg_grep#grep(input)"{{{
	let l:result = unite#util#system('hg grep -n ' . a:input . ' .')
	let l:matches = split(result, '\r\n\|\r\|\n')
  let l:entries = map(l:matches, 'split(v:val, ":")')
  return map(l:entries,
    \ '{
    \   "word": join([v:val[0], v:val[2], join(v:val[3:], ":")], ":"),
    \   "source": "vcs_grep/hg",
    \   "kind": "jump_list",
    \   "action__path": v:val[0],
    \   "action__line": v:val[2],
    \   "action__text": join(v:val[3:], ":"),
    \ }')
endfunction"}}}

" vim: foldmethod=marker
