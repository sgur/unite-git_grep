"=============================================================================
" FILE: git_grep.vim
" Last Modified: 29 Jun 2011.
" Description: A source that invokes 'git grep' from :Unite
" Usage: :Unite git_grep<Return>
" Notes:
"=============================================================================
function! unite#sources#git_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'vcs_grep/git',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 30,
			\ 'required_pattern_length': 3,
			\ 'hooks'    : {},
			\ }

function! s:source.hooks.on_init(args, context)"{{{
	if !unite#sources#git_grep#check()
		call unite#util#print_error('Not a Git repoitory.')
	endif
endfunction"}}}

function! s:source.change_candidates(args, context)"{{{
	return unite#sources#git_grep#grep(a:context.input)
endfunction"}}}

function! unite#sources#git_grep#check()"{{{
	call unite#util#system('git rev-parse')
	return (unite#util#get_last_status() == 0)? 1 : 0
endfunction"}}}

function! unite#sources#git_grep#grep(input)"{{{
	let l:result = unite#util#system('git grep -n ' . a:input)
	let l:matches = split(l:result, '\r\n\|\r\|\n')
  let l:entries = map(l:matches, '[v:val, split(v:val, ":")]')
  return map(l:entries,
    \ '{
    \   "word": v:val[0],
    \   "source": "vcs_grep/git",
    \   "kind": "jump_list",
    \   "action__path": v:val[1][0],
    \   "action__line": v:val[1][1],
    \   "action__text": join(v:val[1][2:], ":"),
    \ }')
endfunction"}}}

" vim: foldmethod=marker
