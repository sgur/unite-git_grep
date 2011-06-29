"=============================================================================
" FILE: vcs_grep.vim
" Last Modified: 29 Jun 2011.
" Description: A source that invokes 'git grep' / 'hg grep -n' from :Unite
" Usage: :Unite vcs_grep<Return>
" Notes:
"=============================================================================
function! unite#sources#vcs_grep#define()"{{{
	return s:source
endfunction"}}}

let s:source = {
			\ 'name'           : 'vcs_grep',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 30,
			\ 'required_pattern_length': 3,
			\ 'hooks'    : {},
			\ }

function! s:source.hooks.on_init(args, context)"{{{
	let s:vcs_type = 'unknown'
	" Git
	if unite#sources#git_grep#check()
		let s:vcs_type = 'git'
		return
	endif
	" Hg
	if unite#sources#hg_grep#check()
		let s:vcs_type = 'hg'
		return
	endif
	call unite#util#print_error('No repos found.')
endfunction"}}}

" hg grep -n
function! s:source.change_candidates(args, context)"{{{
	if s:vcs_type == 'git'
		return unite#sources#git_grep#grep(a:context.input)
	elseif s:vcs_type == 'hg'
		return unite#sources#hg_grep#grep(a:context.input)
	else
		return []
	endif
endfunction"}}}

" vim: foldmethod=marker
