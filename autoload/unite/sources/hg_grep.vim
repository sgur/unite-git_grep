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
	let result = unite#util#system('hg grep -n ' . a:input . ' .')
	let candidates = split(result, '\r\n\|\r\|\n')
	let sub_path = s:sub_path()
	return map(candidates, 's:format_candidate('
				\ . 'substitute(v:val, ":\[0-9\]\\ze:", "", ""), '
				\ . 'sub_path)')
endfunction"}}}

function! s:sub_path()"{{{
	let root = unite#util#system('hg root')[0:-2]
	return unite#util#substitute_path_separator(strpart(getcwd(), len(root))) .'/'
endfunction"}}}

function! s:format_candidate(entry, sub_path)"{{{
	let matches = matchlist(a:entry, '^\([^:]\+\ze\):\(\zs[0-9]\+\ze\):')
	let skip = len(matchstr(matches[1], a:sub_path[1:]))
	return {
				\ 'word': strpart(a:entry, skip),
				\ 'source': 'vcs_grep/hg',
				\ 'kind' : 'jump_list',
				\ 'action__path': strpart(matches[1], skip),
				\ 'action__line': matches[2],
				\ }
endfunction"}}}

" vim: foldmethod=marker
