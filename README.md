# Neovim-Setting

原始版本無框架的 Neovim 設定檔。

> Clone 完 要將資料夾改成 nvim

> C:\Users\YourUserName\AppData\Local\nvim 把 init 放在這裡

---

### 📦 BufferLine（plugin.config.keymaps.lua）

| 快捷鍵     | 指令/函數           | 說明                | 來源檔案    |
| ---------- | ------------------- | ------------------- | ----------- |
| <Tab>      | BufferLineCycleNext | 切換到下一個 Buffer | 自定 keymap |
| <S-Tab>    | BufferLineCyclePrev | 切換到上一個 Buffer | 自定 keymap |
| <leader>bc | BufferLinePickClose | 選擇關閉 Buffer     | 自定 keymap |
| <leader>bd | :bdelete            | 關閉當前 Buffer     | 自定 keymap |

---

### 🌠 Flash.nvim（plugin/config/flash.lua）

| 快捷鍵     | 指令/函數               | 說明                | 來源檔案                |
| ---------- | ----------------------- | ------------------- | ----------------------- |
| <leader>hf | flash.jump              | Hop Flash           | plugin/config/flash.lua |
| <leader>hF | flash.treesitter        | Flash Treesitter    | plugin/config/flash.lua |
| <leader>hr | flash.treesitter_search | Treesitter Search   | plugin/config/flash.lua |
| he         | flash.toggle            | Toggle Flash Search | plugin/config/flash.lua |

---

### 🌳 Treesitter 增量選取（plugin/config/lsp.lua）

| 快捷鍵 | 指令/函數         | 說明           | 來源檔案              |
| ------ | ----------------- | -------------- | --------------------- |
| gnn    | init_selection    | 初始化選取區塊 | plugin/config/lsp.lua |
| grn    | node_incremental  | 擴展選取區塊   | plugin/config/lsp.lua |
| grc    | scope_incremental | 擴展至範圍     | plugin/config/lsp.lua |
| grm    | node_decremental  | 縮減選取區塊   | plugin/config/lsp.lua |

---

### 🔭 Telescope（plugin/config/telescope.lua）

| 快捷鍵     | 指令/函數             | 說明                  | 來源檔案                    |
| ---------- | --------------------- | --------------------- | --------------------------- |
| <leader>ff | Telescope find_files  | 尋找檔案              | plugin/config/telescope.lua |
| <leader>fg | Telescope live_grep   | 即時文字搜尋          | plugin/config/telescope.lua |
| <leader>fb | Telescope buffers     | 顯示所有開啟的 Buffer | plugin/config/telescope.lua |
| <leader>fh | Telescope help_tags   | 幫助文件搜尋          | plugin/config/telescope.lua |
| <leader>td | Telescope diagnostics | LSP 診斷列表          | plugin/config/telescope.lua |

---

### 🧠 LSP（plugin/config/mason.lua）

| 快捷鍵    | 指令/函數                 | 說明             | 來源檔案                    |
| --------- | ------------------------- | ---------------- | --------------------------- |
| gd        | vim.lsp.buf.definition    | 跳轉至定義       | plugin/config/mason.lua     |
| K         | vim.lsp.buf.hover         | 顯示提示         | plugin/config/mason.lua     |
| ca        | vim.lsp.buf.code_action   | 顯示 Code Action | plugin/config/telescope.lua |
| <leader>e | vim.diagnostic.open_float | 顯示行內診斷訊息 | plugin/config/telescope.lua |

---

### ✍️ nvim-cmp（plugin/config/lsp.lua）

| 快捷鍵      | 指令/函數            | 說明               | 來源檔案              |
| ----------- | -------------------- | ------------------ | --------------------- |
| `<C-y>`     | cmp.mapping.confirm  | 確認補全           | plugin/config/lsp.lua |
| `<C-Space>` | cmp.mapping.complete | 顯示補全清單       | plugin/config/lsp.lua |
| `<Tab>`     | cmp.select_next_item | 選擇下一個補全項目 | plugin/config/lsp.lua |
| `<S-Tab>`   | cmp.select_prev_item | 選擇上一個補全項目 | plugin/config/lsp.lua |
| `<CR>`      | cmp.mapping.confirm  | 確認補全（Enter）  | plugin/config/lsp.lua |

---

### 🛠️ 你自定義的快捷指令（plugin/config/init.lua or keymaps.lua）

| 快捷鍵     | 指令/函數                 | 說明             | 來源檔案                  |
| ---------- | ------------------------- | ---------------- | ------------------------- |
| <leader>bc | BufferLinePickClose       | 選擇關閉 Buffer  | plugin/config/keymaps.lua |
| <leader>bd | :bdelete                  | 關閉當前 Buffer  | plugin/config/keymaps.lua |
| <leader>e  | vim.diagnostic.open_float | 顯示行內診斷訊息 | plugin/config/keymaps.lua |
| <leader>td | Telescope diagnostics     | LSP 診斷列表     | plugin/config/keymaps.lua |

### 🧰 自定義 User Commands

| 指令             | 說明                        | 來源檔案                                        |
| ---------------- | --------------------------- | ----------------------------------------------- |
| :MasonToggle     | 切換 Mason / LSP 啟用與關閉 | plugin/config/mason.lua                         |
| :ToggleDevConfig | 啟用 / 關閉開發環境所有設定 | plugin/config/init.lua 或 plugin/config/dev.lua |
