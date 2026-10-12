# 使用プラグインと依存ツール

この文書は、現在の設定を新しい環境で再現するときに必要なプラグイン、CLI、言語別ツールをまとめた一覧である。内容は `lua/plugins/*.lua`、`lazy-lock.json`、`install.sh` を **2026-10-12** に照合した結果であり、lockfile の revision が実際に導入する版を決める。

まず Neovim を起動すると lazy.nvim が未導入プラグインを Git で取得する。外部 CLI は lazy.nvim では導入されないため、使う機能に応じて別途 `PATH` に置く。

## 共通の依存ツール

| 区分 | ツール | 必要な機能 | 導入・確認 |
| --- | --- | --- | --- |
| 必須 | Neovim 0.12 以上 | この設定の LSP API と nvim-treesitter `main` | `nvim --version` |
| 必須 | Git | lazy.nvim の bootstrap とプラグイン取得、Git 系プラグイン | `git --version` |
| 必須 | `tree-sitter` CLI 0.26.1 以上 | nvim-treesitter による parser の生成 | macOS: `brew install tree-sitter-cli`、`tree-sitter --version` |
| 必須 | C compiler | Tree-sitter parser のコンパイル | `cc --version` |
| 必須 | curl | parser の HTTP ダウンロード、CopilotChat | `curl --version` |
| 必須 | tar | nvim-treesitter の parser 配布物の展開 | `tar --version` |
| 機能別 | ripgrep (`rg`) | Telescope の `<leader>g`（`live_grep`）、CopilotChat の検索性能 | macOS: `brew install ripgrep`、`rg --version` |
| 機能別 | Make | CopilotChat の設定済み build hook `make tiktoken` | `make --version` |
| 任意 | fd | Telescope のファイル探索を改善 | macOS: `brew install fd` |
| 任意 | clipboard provider | `clipboard=unnamedplus` による OS クリップボード共有 | `:checkhealth clipboard` |
| 任意 | Nerd Font | nvim-tree 等のアイコン表示 | ターミナルのフォント設定で選択 |

`tree-sitter` は parser を解析・生成する **CLI** であり、`tree-sitter-cli` はその Homebrew パッケージ名である。Lua の Tree-sitter runtime や Neovim 同梱の機能だけでは、この設定が行う parser ビルドを代替できない。npm の同名パッケージではなく、nvim-treesitter が案内するシステムパッケージを使う。

`make tiktoken` は C/C++ をコンパイルする処理ではなく、macOS/Linux 向け `tiktoken_core` バイナリを curl で取得する Makefile target である。CopilotChat 本体には curl 8.0.0 以上、plenary.nvim、GitHub 側で有効化した Copilot Chat が必要で、正確な token count はこの任意モジュールにより改善される。

## プラグイン

「直接」は `lua/plugins/` でこの設定が宣言するプラグイン、「間接」は直接プラグインの依存としてだけ導入されるものを表す。設定元は、特記しない限り `lua/plugins/` 配下のファイル名である。

| プラグイン | 導入 | 用途 | 設定元 | 外部依存・備考 |
| --- | --- | --- | --- | --- |
| `folke/lazy.nvim` | 直接 | 取得、更新、lockfile、遅延読み込み | `lua/config/lazy.lua` | Git |
| `folke/tokyonight.nvim` | 直接 | カラースキーム | `colorschema.lua` | なし |
| `nvim-telescope/telescope.nvim` | 直接 | file/grep/quickfix picker | `telescope.lua` | `live_grep` は ripgrep、plenary に依存 |
| `nvim-lua/plenary.nvim` | 間接 | Telescope/CopilotChat の Lua utility | `telescope.lua`、`copilot.lua` | なし |
| `nvim-tree/nvim-tree.lua` | 直接 | ファイルツリー、Git/変更状態表示 | `tree.lua` | Git 表示には Git、アイコンは devicons |
| `nvim-tree/nvim-web-devicons` | 直接 | ファイルアイコン | `nvim-web-devicons.lua` | Nerd Font は任意 |
| `nvim-treesitter/nvim-treesitter` | 直接 | parser 管理と構文ハイライト | `treesitter.lua` | `tree-sitter` CLI、C compiler、curl |
| `neovim/nvim-lspconfig` | 直接 | LSP server defaults | `lsp.lua` | 各 LSP 実行ファイル |
| `hrsh7th/nvim-cmp` | 直接 | insert/command-line 補完 UI | `cmp.lua` | 下記 cmp source |
| `hrsh7th/cmp-nvim-lsp` | 間接 | LSP 補完 source と capabilities | `cmp.lua`、`lsp.lua` | nvim-lspconfig と LSP server |
| `hrsh7th/cmp-buffer` | 間接 | buffer 内補完 source | `cmp.lua` | なし |
| `hrsh7th/cmp-path` | 間接 | command-line path 補完 source | `cmp.lua` | なし |
| `hrsh7th/cmp-cmdline` | 間接 | `:`/`/`/`?` 補完 source | `cmp.lua` | なし |
| `hrsh7th/cmp-nvim-lua` | 間接 | Lua API 補完 source | `cmp.lua` | source としては未登録 |
| `stevearc/conform.nvim` | 直接 | 保存時・範囲指定の整形 | `formatter.lua` | filetype ごとの formatter |
| `github/copilot.vim` | 直接 | Copilot inline suggestion/認証 | `copilot.lua` | Node.js、GitHub Copilot の利用権限 |
| `CopilotC-Nvim/CopilotChat.nvim` | 直接 | Copilot Chat UI | `copilot.lua` | curl、Copilot Chat 有効化、plenary、`make tiktoken` は設定済み |
| `tpope/vim-fugitive` | 直接 | Git porcelain 操作 | `git.lua` | Git |
| `tpope/vim-rhubarb` | 直接 | fugitive の GitHub URL 連携 | `git.lua` | Git、GitHub remote を使う機能 |
| `akinsho/git-conflict.nvim` | 直接 | conflict marker の表示・解決支援 | `git.lua` | Git conflict を扱う場合 |
| `nvim-lualine/lualine.nvim` | 直接 | statusline | `lualine.lua` | なし |
| `lukas-reineke/indent-blankline.nvim` | 直接 | インデントガイド | `plugins.lua` | なし |
| `norcalli/nvim-colorizer.lua` | 直接 | 色 literal の表示 | `plugins.lua` | なし |
| `simeji/winresizer` | 直接 | ウィンドウサイズ変更 UI | `plugins.lua` | なし |
| `folke/which-key.nvim` | 直接 | キーマップの発見 UI | `whichkey.lua` | なし |

コメントアウトされた `nvim-surround`、`nord.nvim`、`oxocarbon.nvim` は有効な plugin spec ではないため一覧に含めない。

## LSP server

`lua/plugins/lsp.lua` は次の 6 server を有効化する。必要なのは編集する言語に対応する行だけであり、すべての server を一律に導入する必要はない。実行コマンドは nvim-lspconfig の現在 lock された定義と、`phpactor` の明示設定から確認した。

| server | 対象 | 実行コマンド | 導入の目安 |
| --- | --- | --- | --- |
| `lua_ls` | Lua | `lua-language-server` | macOS: `brew install lua-language-server` |
| `ts_ls` | JavaScript / TypeScript / React | `typescript-language-server --stdio` | `npm install -g typescript typescript-language-server`。現行 server は TypeScript 7 未満を要求する注記があるため、導入時に公式 README を確認する。 |
| `phpactor` | PHP | `phpactor language-server` | PHP と Composer を前提に、[Phpactor の導入手順](https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation)に従う。 |
| `gopls` | Go、go.mod、go.work、Go template | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| `ruby_lsp` | Ruby / ERB | `ruby-lsp` | `gem install ruby-lsp` |
| `ziggy` | Ziggy data serialization | `ziggy lsp` | [Ziggy LSP の導入手順](https://ziggy-lang.io/documentation/ziggy-lsp/)に従う。 |

## Conform formatter

`<leader>i` または保存時に Conform は、利用可能な formatter を指定順に実行する。表のコマンドが `PATH` にない場合は、LSP formatting へ fallback するか、formatter がない旨を通知する。下記は設定に記載された名前であり、未導入の formatter が動作することを意味しない。

| filetype | 設定された formatter | 必要なコマンド・注意 |
| --- | --- | --- |
| Lua | `stylua` | `stylua` |
| Go | `goimports` → `gofmt` | `goimports` と Go 同梱の `gofmt`。`go install golang.org/x/tools/cmd/goimports@latest` |
| PHP | `phpcbf` | PHP_CodeSniffer の `phpcbf` |
| JavaScript / JSX | `biome` → `biome-check` → `prettierd` | `biome` と `prettierd`。`biome-check` は Conform の formatter 名で、現在の設定との適合は未検証。 |
| TypeScript | `biom` → `biome-check` → `prettierd` | `biom` は設定上の名称であり、一般的な `biome` と異なる。実行可否を要確認。 |
| TSX | `biome` → `biome-check` → `prettierd` | `biome` と `prettierd`。`biome-check` は Conform の formatter 名で、現在の設定との適合は未検証。 |
| JSON | `biome` → `biome-check` → `prettierd` | `biome` と `prettierd` |
| SQL | inline `sql-formatter -i` | `sql-formatter`。独自 command 指定であり、現行 Conform で有効かは未検証。 |
| Terraform | `terraform_fmt` | Terraform CLI（実行時は `terraform fmt`） |
| 全 filetype | `trim_whitespace` | Conform 組み込み formatter |

既存の `install.sh` は TypeScript LSP、lua-language-server、gopls、goimports、prettierd だけを導入する。上表の他の LSP server と formatter は、使用する場合に追加する。

## 確認コマンド

導入後は Neovim で `:checkhealth` を実行し、必要に応じて `:checkhealth telescope`、`:checkhealth vim.lsp`、`:checkhealth clipboard` を確認する。Tree-sitter の parser 失敗は `tree-sitter --version` と `cc --version` を、`<leader>g` の失敗は `rg --version` を最初に確認する。

## 参照資料

- [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- [Telescope requirements](https://github.com/nvim-telescope/telescope.nvim#requirements)
- [CopilotChat requirements](https://github.com/CopilotC-Nvim/CopilotChat.nvim#requirements)
- [copilot.vim](https://github.com/github/copilot.vim)
- [Neovim `:checkhealth`](https://neovim.io/doc/user/provider.html)
