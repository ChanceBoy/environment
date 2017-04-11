set clipboard=unnamed
noremap <silent> <C-p> "0p<CR>

set ignorecase
set smartcase
 
set cursorline

set number

"syntax on
"colorscheme molokai
"set t_Co=256

call pathogen#infect()
"call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

syntax on
filetype plugin indent on

" grep結果を別ウィンドウで表示する
autocmd QuickFixCmdPost *grep* cwindow

"" 現在の表示ページの一番下へカーソル移動
"" <S-j>のdefault:次の行を現在行に結合する
"noremap <C-j> <S-l>
"" 現在の表示ページの一番上へカーソル移動
"" <S-k>のdefault:カーソルの下の単語からマニュアルを引く
"noremap <C-k> <S-h>

set noundofile
set nobackup

" sキー割り当て
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>

nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>

" 単語選択
nnoremap vv viw

" 置換コマンド
nnoremap <C-h> :%s/
vnoremap <C-h> :s/

set backspace=indent,eol,start

set hlsearch

set nowrap

" markdownのハイライトを有効にする
"set syntax=markdown
"au BufRead,BufNewFile *.md set filetype=markdown
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

nnoremap o oX<C-h>
nnoremap O OX<C-h>
inoremap <CR> <CR>X<C-h>

"タブ切り替え
nnoremap <C-Tab>   gt
nnoremap <C-S-Tab> gT

" 入力モード時日本語デフォルトOFF
set iminsert=0
" 検索時のデフォルト値. -1はiminsertを参照する
set imsearch=-1

" ESCを別キーに割り当て
"noremap <C-j> <Esc>
"noremap! <C-j> <Esc>
 
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
""" unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=0
" ヤンク履歴
let g:unite_source_history_yank_enable =1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <S-f> :<C-u>Unite file_rec<CR>
inoremap <silent> <S-f> <ESC>:<C-u>Unite file_rec<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
"au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
"au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" ディレクトリは vimfiler で開く
call unite#custom#default_action('directory' , 'vimfiler')
call unite#custom#default_action('file', 'vimfiler')

" after/ftplugin/unite.vim
"nnoremap <silent> <buffer> f :<C-u>call unite#mappings#do_action('vimfiler')<CR>
"nnoremap <silent> <buffer> t :<C-u>call unite#mappings#do_action('tabopen')<CR>
"nnoremap <silent> <buffer> <expr> f <SID>do_action('vimfiler')
"nnoremap <silent> <buffer> <expr> t <SID>do_action('tabopen')

""""""""""""""""""""""""""
"VimFiler

"uniteを開いている間のキーマッピング
augroup vimrc
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  "sでsplit
  nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  "vでvsplit
  nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  "fでvimfiler
  nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
endfunction

"ブックマーク開く
nnoremap <silent> sb :<C-u>Unite bookmark<CR>

" Eキーを押した時、新規タブで開かれる
let g:vimfiler_edit_action = 'tabopen'

"vimデフォルトのエクスプローラをvimfilerで置き換える
"let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
" 最大履歴保存数
let g:vimfiler_max_directories_history = 256
" CD自動で実行
let g:vimfiler_enable_auto_cd=1
"現在開いているバッファのディレクトリを開く
"nnoremap <silent> sfe :<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> sf :<C-u>VimFilerBufferDir -double<CR>
"nnoremap <silent> sf :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
"nnoremap <silent> sf :<C-u>VimFilerBufferDir -split -simple -no-quit<CR>
"nnoremap sf :VimFiler -split -simple -winwidth=35 -no-quit<CR>

