"=============================================================================
" FILE: hg_grep.vim
" Last Modified: 29 Jun 2011.
" Description: A source that invokes 'hg grep -n .' from :Unite
" Usage: :Unite hg_grep<Return>
" Notes:
"=============================================================================

" Variables  "{{{
call unite#util#set_default('g:unite_source_hg_grep_required_pattern_length', 3)
call unite#util#set_default('g:unite_source_hg_grep_max_candidates', 100)
"}}}

function! unite#sources#hg_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'vcs_grep/hg',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : g:unite_source_hg_grep_max_candidates,
			\ 'required_pattern_length': g:unite_source_hg_grep_required_pattern_length,
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
	let result = unite#util#system('hg grep -n ' . a:input . ' .')
	let matches = split(result, '\r\n\|\r\|\n')
	let root = unite#util#system('hg root')[0:-2]
	let sub_path = unite#util#substitute_path_separator(strpart(getcwd(), len(root))) .'/'
	let candidates = []
	for entry in matches
		let entry = substitute(entry, ':[0-9]\ze:', '', 'g')
		let path = matchstr(entry, '^[^:]\+\ze:')
		let line = matchstr(entry, '^[^:]\+:\zs[0-9]\+\ze:')
		let skip = len(matchstr(path, sub_path[1:]))
		let dict = {
					\ 'word': strpart(entry, skip),
					\ 'source': 'vcs_grep/hg',
					\ 'kind' : 'jump_list',
					\ 'action__path': strpart(path, skip),
					\ 'action__line': line,
					\ }
		call add(candidates, dict)
	endfor
	return candidates
endfunction"}}}

" vim: foldmethod=marker
