autocmd BufNewFile,BufRead *.liquid set ft=liquid
autocmd BufNewFile,BufRead */_layouts/*.html set ft=liquid
autocmd BufNewFile,BufRead *.html,*.xml,*.markdown,*.textile,*.md
      \ if getline(1) == '---' | set ft=liquid | endif
