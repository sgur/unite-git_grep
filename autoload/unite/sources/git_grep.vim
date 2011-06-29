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
	let result = unite#util#system('git grep -n ' . a:input)
	let candidates = split(result, '\r\n\|\r\|\n')
	return map(candidates, 's:format_candidate(v:val)')
endfunction"}}}

function! s:format_candidate(entry)"{{{
	let matches = matchlist(a:entry, '^\([^:]\+\ze\):\(\zs[0-9]\+\ze\):')
	return {
				\ 'word': a:entry,
				\ 'source': 'vcs_grep/git',
				\ 'kind' : 'jump_list',
				\ 'action__path': matches[1],
				\ 'action__line': matches[2],
				\ }
endfunction"}}}

" vim: foldmethod=marker
