# Neovim 0.12 プラグイン削減調査

> この文書は移行前構成を対象にした調査時点のスナップショットである。現在のプラグイン構成と依存ツールは[使用プラグインと依存ツール](plugins-and-tools.md)を参照する。

## 結論

現在の `lazy-lock.json` にある 25 プラグインを対象に、Neovim 0.12.0 の標準機能で置換できる範囲を調査した。

| 段階 | 削除対象 | 残数 | 判断 |
| --- | --- | ---: | --- |
| 現状 | なし | 25 | 基準値 |
| 即時 | `cmp-nvim-lua` | 24 | 設定に source 登録がなく未使用 |
| 基本案 | nvim-cmp 系 6 本、`lazy.nvim` | 18 | 0.12 の補完と `vim.pack` へ移行。ただし後述の差分対応が必要 |
| 条件付き案 | 基本案 + `nvim-colorizer.lua` + `lualine.nvim` | 16 | 色表示と statusline の機能差を受け入れる場合 |

削除数は重複計上していない。nvim-cmp 系 6 本は `nvim-cmp`、`cmp-nvim-lsp`、`cmp-buffer`、`cmp-path`、`cmp-cmdline`、`cmp-nvim-lua` を指す。基本案では、即時削除の `cmp-nvim-lua` もこの 6 本に含まれる。

推奨は、まず未使用の 1 本を削除し、次に補完を移行してから、最後にプラグインマネージャーを移行する順序である。`vim.pack` は実験的 API であり、lazy.nvim のロード仕様を自動変換しないため、補完移行と同時に変えるより切り分けた方が確認しやすい。

## 調査範囲と前提

- 現状の根拠: [`lazy-lock.json`](../lazy-lock.json) と [`lua/plugins/`](../lua/plugins/)
- 対象バージョン: Neovim 0.12.0
- 公式資料は Neovim リポジトリの `v0.12.0` タグへ固定した。
- 設定変更、Neovim 本体更新、プラグイン更新、実機での起動確認は行っていない。
- 「置換可能」は、現在使っている主要用途を標準機能で構成できるという意味であり、UI、候補順、対応対象まで同一とは限らない。

## 0.12 で新たに可能になる削減

### lazy.nvim を `vim.pack` へ置換

Neovim 0.12 の [`vim.pack`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/pack.txt) は Git リポジトリの追加、更新、削除、バージョン指定、lockfile を標準提供する。したがって、インストールと更新の管理だけなら `lazy.nvim` を削除できる。

ただし [`vim.pack.Spec`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/pack.txt#L402-L414) の標準フィールドは `src`、`name`、`version`、`data` である。現在使っている lazy.nvim 固有の指定は、次のように別途実装する必要がある。

| 現行指定 | 該当設定 | `vim.pack` 移行時の扱い |
| --- | --- | --- |
| `event = "VeryLazy"` | nvim-tree、which-key | autocmd と `:packadd`、または `vim.pack.add()` の `load` 関数で再構成 |
| `keys` | conform、Telescope、nvim-tree、which-key | 先行 keymap からロードして本来の処理を再実行するか、起動時ロードへ変更 |
| `dependencies` | cmp、CopilotChat、Telescope | 依存先を先に `vim.pack.add()` し、ロード順を明示。仕様自体に依存解決フィールドはない |
| `build = "make tiktoken"` | CopilotChat | `PackChanged` の install/update hook で実行し、終了状態も検査 |
| `opts` | CopilotChat、lualine、Telescope | `require(...).setup(opts)` を明示的に呼ぶ |
| `config` | 多数 | ロード後に明示的に実行 |
| `lazy = false`、`priority` | colorscheme、Telescope、treesitter | 呼び出し順で起動時ロード順を保証 |

`vim.pack.add()` は init.lua 読み込み中、既定では plugin scripts を直ちにロードしない。`opts.load` で挙動を変えられるため、設定適用の時点を設計する必要がある。また公式文書自身が `vim.pack` を experimental としている。lockfile は手編集せず、設定と一緒に管理する。

### nvim-cmp 系を標準補完へ置換

現行の [`cmp.lua`](../lua/plugins/cmp.lua) は、Insert mode で `nvim_lsp` と `buffer`、`/` と `?` で `buffer`、`:` で `path` と `cmdline` を使う。

Neovim 0.12 の [`'autocomplete'`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/options.txt) と [`ins-autocompletion`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/insert.txt) を有効にし、`'complete'` へバッファ source と omnifunc を指定すれば、Insert mode の buffer + LSP 補完を構成できる。LSP は [`vim.lsp.completion.enable()`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/lsp.txt) で有効にする。0.12 では同 API に候補順を調整する `cmp` option も追加された。

置換時の注意点は次のとおり。

- `cmp-buffer`: `'complete'` の `.`, `w`, `b`, `u` などで代替できる。どのバッファまで検索するかを現行相当に絞る必要がある。
- `cmp-nvim-lsp`: 標準 LSP completion はクライアント capabilities と統合されるため、source plugin は不要になる。ただし [`lsp.lua`](../lua/plugins/lsp.lua) と `cmp.lua` の双方でサーバーを setup している現状を一本化し、snippet、resolve、additionalTextEdits、preselect の挙動を各サーバーで確認する。
- `cmp-path`: Insert mode のファイル名補完は標準の `CTRL-X CTRL-F` があるが、現在の通常補完 source には path を登録していない。`:` の path 補完は command-line 標準機能が文脈に応じて提供する。
- `cmp-cmdline`: [`cmdline-autocompletion`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/cmdline.txt) の `CmdlineChanged` + `wildtrigger()` と `wildmode` / `wildoptions=pum` で、`:`、`/`、`?` に入力中 popup を出せる。これは context-sensitive な標準候補であり、nvim-cmp と候補の混合順、matching、keymap は同一ではない。
- `cmp-nvim-lua`: 現在 `dependencies` にあるだけで `sources` に登録されていないため、0.12 移行を待たず削除できる。
- UI と keymap: `<C-b>/<C-f>` の docs scroll、`<C-Space>`、`<C-e>`、`<CR>` の選択確定を標準 popup 用に再設定する。`completeopt` の `popup`、`preselect`、`fuzzy` なども明示する。

特に `/` と `?` は、現行では buffer source を nvim-cmp の popup に出す。標準 command-line autocompletion でも検索候補を表示できるが、同じ絞り込み・選択動作であることは移行後に確認が必要である。

### Copilot の inline completion

0.12 は LSP `textDocument/inlineCompletion` を [`vim.lsp.inline_completion`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/lsp.txt) として標準実装した。公式 quickstart は `@github/copilot-language-server` をインストールし、Copilot LSP config、サインイン、`vim.lsp.inline_completion.enable()`、accept/select keymap を設定する例を示す。この構成なら [`copilot.vim`](../lua/plugins/copilot.lua) の inline suggestion 部分は置換候補になる。

ただし標準機能は Copilot サービスそのものを内蔵しない。外部 language server のインストールと認証が必要である。また現行の CopilotChat は `copilot.vim` を依存として宣言しているため、CopilotChat を維持したまま `copilot.vim` を削除できるかは CopilotChat 側の provider 対応を別途確認する必要がある。このため 25→18 の基本案には Copilot の削除を含めない。

### nvim-colorizer.lua

0.12 の [`vim.lsp.document_color`](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/lsp.txt) は LSP の `textDocument/documentColor` が返す色参照を表示し、`background`、`foreground`、`virtual` を選べる。色表現の選択には `colorPresentation` も使える。

これは colorizer の全面的な互換機能ではない。LSP server が document color を実装する filetype と色記法だけが対象であり、LSP なしのファイルや colorizer 独自 parser が認識する任意の色 literal は対象外になる。現在構成している 6 server は `ts_ls`、`gopls`、`lua_ls`、`ruby_lsp`、`ziggy`、`phpactor` で、CSS/HTML 用 server はない。現構成で `textDocument/documentColor` provider が利用可能かは実機で確認できておらず、colorizer を削除するだけで同等になるとは判断できない。現在の [`plugins.lua`](../lua/plugins/plugins.lua) は引数なしで全既定対象を有効化しているため、各 filetype で `client:supports_method('textDocument/documentColor')` と表示対象を確認してから削除する。

`vim.lsp.document_color`、既定の色 highlight、`textDocument/colorPresentation` 対応は 0.12 の追加機能である。この条件付き削減も 0.12 固有として扱う。

## 以前から標準機能で可能な条件付き削減

### lualine.nvim

Neovim の statusline は以前から `'statusline'` と statusline expression で構成できる。加えて 0.12 の既定 statusline は式として公開され、`vim.diagnostic.status()`、`vim.ui.progress_status()`、terminal exit code を表示する。現在の [`lualine.lua`](../lua/plugins/lualine.lua) のうち diagnostics は標準既定表示で賄いやすくなる。`vim.ui.progress_status()` はバックグラウンド処理の進捗であり、lualine の `progress` が示すファイル内の位置とは別物である。

一方で、mode、path 付き filename、Git branch、encoding、filetype、location、active/inactive window、幅に応じた短縮、配色まで現行相当にするなら追加実装が必要である。特に Git branch は標準既定 statusline に含まれない。statusline の自作自体は 0.12 固有ではないが、0.12 の既定表示で許容できる場合は削減コストが下がる。

## 全 25 プラグインの評価

| プラグイン | 現在の用途 | 判定 | 根拠・注意点 |
| --- | --- | --- | --- |
| CopilotChat.nvim | AI chat | 維持 | 標準 inline completion は chat UI を代替しない |
| cmp-buffer | buffer 補完 | 0.12 で削除 | `'complete'` で置換 |
| cmp-cmdline | `:`, `/`, `?` 補完 | 0.12 で削除 | 標準 cmdline autocompletion へ。操作差を確認 |
| cmp-nvim-lsp | LSP completion source | 0.12 で削除 | `vim.lsp.completion.enable()` へ |
| cmp-nvim-lua | Lua API 補完 source | 即時削除 | source 未登録 |
| cmp-path | command-line path source | 0.12 で削除 | 文脈依存の標準 command-line filename completion へ |
| conform.nvim | 外部 formatter と保存時整形 | 維持 | 複数 formatter、fallback、range、保存時処理を統合している |
| copilot.vim | Copilot inline suggestion | 条件付き | Copilot language server + 標準 inline completion へ移行可能。CopilotChat 依存を要確認 |
| git-conflict.nvim | conflict 表示・操作 | 維持 | 標準 Git conflict marker 編集だけでは現在の UX を直接代替しない |
| indent-blankline.nvim | indent guide | 維持 | 標準 listchars 等とは表示機能が異なる |
| lazy.nvim | install、lock、遅延ロード、設定適用 | 0.12 で削除 | `vim.pack` + 明示的 loader/hook へ |
| lualine.nvim | statusline | 条件付き削除 | 標準 statusline で自作可能。保守コスト増 |
| nvim-cmp | 補完 UI と source 統合 | 0.12 で削除 | Insert/LSP/cmdline の標準補完へ分割移行 |
| nvim-colorizer.lua | 色 literal の表示 | 条件付き削除 | LSP document color の対応範囲だけで足りる場合 |
| nvim-lspconfig | 6 server の既定 config | 維持推奨 | `vim.lsp.config/enable` で自前管理可能だが、server defaults の保守を引き受ける |
| nvim-tree.lua | file explorer | 維持 | 標準 netrw との UI・操作・Git/modified 表示差が大きい |
| nvim-treesitter | 多言語 parser 管理 | 維持・要移行 | 標準 treesitter API は parser 配布を代替しない。固定版は 0.12 非対応 |
| nvim-web-devicons | file icon | 維持 | nvim-tree 等の表示依存。標準相当なし |
| plenary.nvim | Telescope、CopilotChat の runtime | 維持 | 両方の依存。直接設定がなくても未使用ではない |
| telescope.nvim | finder/picker | 維持 | find_files、live_grep、resume、quickfix 等を統合。標準単体の同等 UI なし |
| tokyonight.nvim | colorscheme | 維持 | 選択している配色そのもの |
| vim-fugitive | Git porcelain | 維持 | 標準機能に同等の Git 操作層なし |
| vim-rhubarb | GitHub URL 連携 | 維持 | fugitive の GitHub 連携を補完 |
| which-key.nvim | keymap discovery UI | 維持 | 0.12 標準の keymap API は popup discoverability を代替しない |
| winresizer | window resize UI | 維持 | 標準 resize command はあるが、現在の対話 UI を直接代替しない |

`nvim-lspconfig` は削除自体は可能である。Neovim 0.11 からの `vim.lsp.config()` / `vim.lsp.enable()` で 6 server を定義できるため、0.12 固有の利点ではない。ただし server ごとの `cmd`、filetypes、root markers、settings の更新を自分で追うことになる。今回の目的が安全なプラグイン削減なら維持を推奨する。なお [`cmp.lua`](../lua/plugins/cmp.lua) と [`lsp.lua`](../lua/plugins/lsp.lua) が同じ server を重複 setup している点は、補完移行時に必ず解消する。

## Neovim 0.12 更新前の Tree-sitter 対応

現在の [`lazy-lock.json`](../lazy-lock.json) は nvim-treesitter を `cf12346a3414fa1b06af75c79faebe7f76df080a` に固定している。この revision の [README](https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/cf12346a3414fa1b06af75c79faebe7f76df080a/README.md) は対応を Neovim 0.10 / 0.11 とし、0.12 は非対応と明記している。

現在の master 系設定で使う `require('nvim-treesitter.configs').setup()` を保ったまま本体だけ 0.12 に更新してはいけない。新しい [main branch README](https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/main/README.md) は full incompatible rewrite とされ、Neovim 0.12 以上、tree-sitter-cli 0.26.1 以上を要求する。parser install は `require('nvim-treesitter').install()`、highlight 起動は FileType autocmd 等から `vim.treesitter.start()` を使う構成へ変わっている。

したがって、次を一つの移行単位として隔離した 0.12 環境で検証し、現行 0.11 環境へ main branch だけを先行適用しない。

1. nvim-treesitter を main 対応 revision へ更新する。
2. [`treesitter.lua`](../lua/plugins/treesitter.lua) の `configs.setup`、`ensure_installed`、`auto_install`、`highlight.enable` を main API に書き換える。
3. tree-sitter-cli 0.26.1 以上と C compiler を確認する。
4. 全指定言語の parser install と highlight 起動を確認する。

## 推奨移行順

1. `cmp-nvim-lua` を削除し、Lua 補完に変化がないことを確認する。
2. 現行 0.11 環境には nvim-treesitter main を先行適用せず、隔離した 0.12 環境で Neovim 本体、nvim-treesitter main、設定書き換え、parser を同時に検証する。成功後に通常環境をまとめて切り替える。
3. nvim-cmp 設定を残した状態で、検証用に標準 Insert/LSP/cmdline 補完の候補、keymap、snippet を整理する。
4. nvim-cmp 系 6 本をまとめて削除し、LSP server setup の重複を解消する。
5. 全プラグインを `vim.pack` spec へ移し、まず起動時ロードで機能を揃える。
6. `event` / `keys` 相当の遅延ロード、CopilotChat build hook、依存順、各 `setup(opts)` を追加し、`lazy.nvim` を削除する。
7. 色表示の実利用範囲を調べ、LSP document color で十分なら colorizer を削除する。
8. statusline の受入条件を決め、標準実装を保守する意思がある場合だけ lualine を削除する。
9. CopilotChat の対応 provider を確認し、可能なら Copilot LSP + inline completion へ移行する。

## 移行後の確認項目

### 起動とパッケージ管理

- clean install で 24 または 18 プラグインが導入され、再起動後も lockfile の revision が再現される。
- colorscheme が UI plugin より先に適用される。
- nvim-tree / which-key の初回 key 操作、Telescope keymap、conform の `Format` が初回から動く。
- CopilotChat の install/update 時だけ `make tiktoken` が成功し、失敗を検出できる。
- Telescope と CopilotChat の前に plenary が利用可能である。

### 補完

- 6 LSP server で候補、snippet、documentation popup、additionalTextEdits、preselect が動く。
- Insert mode で current buffer と意図した他 buffer の候補だけが出る。
- `<C-Space>`、`<C-e>`、`<CR>`、候補移動、documentation scroll が期待どおり動く。
- `/` と `?` が buffer 内検索候補を popup 表示し、履歴移動を壊さない。
- `:` で command、option、file path が文脈に応じて補完され、symbol を含む入力も扱える。

### LSP、表示、周辺機能

- 6 server が対象 filetype と project root で一度だけ起動する。
- Lua workspace library と semantic tokens 無効化が維持される。
- CSS/HTML 等で document color の対象記法と見え方を colorizer と比較する。
- nvim-treesitter の全指定 parser、highlight、Markdown injection を確認する。
- statusline を置換する場合、active/inactive、狭い window、診断、Git branch、modified 表示を確認する。
- Copilot を置換する場合、認証、候補表示、accept、次/前候補、複数行候補、CopilotChat を確認する。

## 公式資料

- [Neovim 0.12.0: vim.pack](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/pack.txt)
- [Neovim 0.12.0: LSP completion / document color / inline completion](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/lsp.txt)
- [Neovim 0.12.0: Insert mode completion](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/insert.txt)
- [Neovim 0.12.0: command-line completion](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/cmdline.txt)
- [Neovim 0.12.0: options](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/options.txt)
- [Neovim 0.12.0: release notes](https://github.com/neovim/neovim/blob/v0.12.0/runtime/doc/news-0.12.txt)
- [nvim-treesitter 固定 revision README](https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/cf12346a3414fa1b06af75c79faebe7f76df080a/README.md)
- [nvim-treesitter main README](https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/main/README.md)
