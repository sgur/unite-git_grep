function! unite#sources#git_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'git_grep',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 30,
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
