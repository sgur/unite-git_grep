"=============================================================================
" FILE: git_grep.vim
" Last Modified: 10 May 2011.
" Description: Unite から git grep を利用するための source
" Usage: :Unite git_grep<Return>
" Notes:
"=============================================================================
function! unite#sources#git_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'git_grep',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 30,
			\ 'required_pattern_length': 3,
			\ }

function! s:source.gather_candidates(args, context)"{{{
	let result = unite#util#system('git grep -n ' . a:context.input)
	let matches = split(result, '\r\n\|\r\|\n')
	let candidates = []
	for entry in matches
		let path = matchstr(entry, '^[^:]\+\ze:')
		let line = matchstr(entry, '^[^:]\+:\zs[0-9]\+\ze:')
		let dict = {
					\ 'word': entry,
					\ 'source': 'git_grep',
					\ 'kind' : 'jump_list',
					\ 'action__path': path,
					\ 'action__line': line,
					\ }
		call add(candidates, dict)
	endfor

	return candidates
endfunction"}}}

" vim: foldmethod=marker
