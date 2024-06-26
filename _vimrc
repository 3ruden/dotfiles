" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない(ときどき面倒な警告が出るだけで役に立ったことがない)
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" クリップボードにコピーできるようにする
set clipboard+=unnamed

" 見た目系
" 行番号を表示
set number
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" 行番号の色
highlight LineNr ctermfg=darkyellow
" 気に食わない色を変更(stringi, numberなど)
highlight Constant ctermfg=darkred
" filetype プラグインによる indent を on にする
filetype plugin indent on


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" C-c連打でハイライト解除
nmap <C-c><C-c> :nohlsearch<CR><Esc>

"backspaceが効かない問題を解決
set backspace=indent,eol,start

" 保管候補のポップアップの色設定
hi Pmenu ctermbg=19 ctermfg=255
hi PmenuSel ctermbg=88 ctermfg=255
hi PmenuSbar ctermbg=19 ctermfg=255

"===========================================
"キーマッピング
"===========================================
"Esc押しづらいので入れておく
inoremap <C-c> <Esc>
"C-aで左端へ
noremap <C-a> ^
"C-eで右端へ
noremap <C-e> $

"インサートモードでも移動
inoremap <C-j>  <down>
inoremap <C-k>  <up>
inoremap <C-h>  <left>
inoremap <C-l>  <right>

"括弧の補完
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" プラグインのセットアップ
" 使用プラグインマネージャー: https://github.com/junegunn/vim-plug
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" ファイルオープンを便利に
Plug 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示できるようにする
Plug 'Shougo/neomru.vim'

" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
""""""""""""""""""""""""""""""
" Unite.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
""""""""""""""""""""""""""""""

" ファイルをtree表示してくれる
Plug 'scrooloose/nerdtree'

" コメントON/OFFを手軽に実行
Plug 'tomtom/tcomment_vim'

" 行末の半角スペースを可視化
Plug 'bronson/vim-trailing-whitespace'

" HTML閉じタグ補完
Plug 'alvan/vim-closetag'
""""""""""""""""""""""""""""""
" closetag.vimの設定
""""""""""""""""""""""""""""""
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_filetypes = 'html,xhtml,php'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

"</と打ったら対応する閉じタグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype php inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype ruby inoremap <buffer> </ </<C-x><C-o>
augroup END
""""""""""""""""""""""""""""""

"対応するタグをハイライト
Plug 'Valloric/MatchTagAlways'
""""""""""""""""""""""""""""""
" MatchTagAlways.vimの設定
""""""""""""""""""""""""""""""
"オプション機能ONにする
let g:mta_use_matchparen_group = 1

"使用するファイルタイプ(phpを追加)
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'php' : 1,
    \ 'ruby' : 1,
    \}
""""""""""""""""""""""""""""""
" スニペット補完プラグイン
Plug 'Shougo/neosnippet'
" 各種スニペット
Plug 'Shougo/neosnippet-snippets'
""""""""""""""""""""""""""""""
"neosnippet-snippetsの設定
""""""""""""""""""""""""""""""
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" <C-k>で、TARGETのところへジャンプ
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" 独自スニペットファイルのあるディレクトリを指定
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory=$HOME.'/.vim/vim-neosnippets/'

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
""""""""""""""""""""""""""""""

" HTMLやCSSの入力を効率化
Plug 'mattn/emmet-vim'
""""""""""""""""""""""""""""""
" emmet-vimの設定
""""""""""""""""""""""""""""""
" キーマップを<c-y>から<c-t>に変更
let g:user_emmet_leader_key='<c-t>'

" lang属性をenからjaに変更
let g:user_emmet_settings = {
\ 'variables' : {
\  'lang' : "ja"
\ }
\}
""""""""""""""""""""""""""""""

" シングルクオートとダブルクオートの入れ替え等
Plug 'tpope/vim-surround'

" css、html、でのインデントの崩れ防止
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5.vim'

" インデントの可視化
Plug 'Yggdroot/indentLine'

" Rails向けのコマンドを提供する
Plug 'tpope/vim-rails'

" endの自動入力
Plug 'tpope/vim-endwise'

"JSのインデントとシンタックスカラー用プラグイン
Plug 'pangloss/vim-javascript'

" Rails向けのコマンドを提供する
Plug 'tpope/vim-rails'

" インデントに色を付けて見やすくする
Plug 'nathanaelkane/vim-indent-guides'
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" ログファイルを色づけしてくれる
Plug 'vim-scripts/AnsiEsc.vim'

" slimファイルをハイライトしてくれる...がplug-vimではインストールできなったので直接いれた
Plug 'slim-template/vim-slim'
" vim-slimのシンタックスハイライトが適用されない問題を解決
autocmd BufNewFile,BufRead *.slim setlocal filetype=slim

" ddc.vim本体(自動補完プラグイン)
Plug 'Shougo/ddc.vim'
" DenoでVimプラグインを開発するためのプラグイン
Plug 'vim-denops/denops.vim'
" ポップアップウィンドウを表示するプラグイン
"Plug 'Shougo/pum.vim'
" カーソル周辺の既出単語を補完するsource
Plug 'Shougo/ddc-around'
" ファイル名を補完するsource
Plug 'LumaKernel/ddc-file'
" 入力中の単語を補完の対象にするfilter
Plug 'Shougo/ddc-matcher_head'
" 補完候補を適切にソートするfilter
Plug 'Shougo/ddc-sorter_rank'
" 補完候補の重複を防ぐためのfilter
Plug 'Shougo/ddc-converter_remove_overlap'

" プログラミング言語の文法に応じて単語の補完や文法ヒントを表示する
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/vim-lsp'


call plug#end()
""""""""""""""""""""""""""""""

" ddcの設定
""""""""""""""""""""""""""""""
call ddc#custom#patch_global('sources', [
 \ 'around',
 \ 'file'
 \ ])
call ddc#custom#patch_global('sourceOptions', {
 \ '_': {
 \   'matchers': ['matcher_head'],
 \   'sorters': ['sorter_rank'],
 \   'converters': ['converter_remove_overlap'],
 \ },
 \ 'around': {'mark': 'Around'},
 \ 'file': {
 \   'mark': 'file',
 \   'isVolatile': v:true,
 \   'forceCompletionPattern': '\S/\S*'
 \ }})
call ddc#enable()
" 参考:
" https://note.com/dd_techblog/n/n97f2b6ca09d8
" https://zenn.dev/shougo/articles/ddc-vim-beta
""""""""""""""""""""""""""""""
