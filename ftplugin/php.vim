" .vim/ftplugin/php.vim by Tobias Schlitt <toby@php.net>.
" No copyright, feel free to use this, as you like.

let PHP_autoformatcomment = 1

" {{{ Settings

" Use php syntax check when doing :make
setlocal makeprg=php\ -l\ %

" Use errorformat for parsing PHP error output
setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Switch syntax highlighting on, if it was not
if !exists("g:syntax_on")
    syntax
endif

" }}} Settings

" {{{ Command mappings

" Map ; to run PHP parser check
" noremap ; :!php5 -l %<CR>

" DEPRECATED in favor of PDV documentation (see below!)
" Map <CTRL>-P to run actual file with PHP CLI
" noremap <C-P> :w!<CR>:!php5 %<CR>

" Map <ctrl>+p to single line mode documentation (in insert and command mode)
inoremap <buffer> <C-P> :call PhpDocSingle()<CR>i
nnoremap <buffer> <C-P> :call PhpDocSingle()<CR>
" Map <ctrl>+p to multi line mode documentation (in visual mode)
vnoremap <buffer> <C-P> :call PhpDocRange()<CR>

" Map <CTRL>-H to search phpm for the function name currently under the cursor (insert mode only)
inoremap <buffer> <C-H> <ESC>:!phpm <C-R>=expand("<cword>")<CR><CR>

" Map <CTRL>-a to alignment function
vnoremap <buffer> <C-a> :call PhpAlign()<CR>

" Map <CTRL>-a to (un-)comment function
vnoremap <buffer> <C-c> :call PhpUnComment()<CR>

" }}}

" {{{ (Un-)comment

func! PhpUnComment() range
    let l:paste = &g:paste
    let &g:paste = 0

    let l:line        = a:firstline
    let l:endline     = a:lastline

	while l:line <= l:endline
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:newline = substitute (getline (l:line), '^\(\s*\)\/\/ \(.*\).*$', '\1\2', '')
		else
			let l:newline = substitute (getline (l:line), '^\(\s*\)\(.*\)$', '\1// \2', '')
		endif
		call setline (l:line, l:newline)
		let l:line = l:line + 1
	endwhile

    let &g:paste = l:paste
endfunc

" }}}
