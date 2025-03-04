-- settings.lua
-- Function to manage editor size
local function manageEditorSize(count, direction)
    count = count or 1
    local action = direction == "increase" and "workbench.action.increaseViewSize" or
                       "workbench.action.decreaseViewSize"
    for i = 1, count do
        vim.fn.VSCodeNotify(action)
    end
end

-- Function for VSCode commentary
local function vscodeCommentary(...)
    local args = {...}
    if #args == 0 then
        vim.o.operatorfunc = "v:lua.vscodeCommentary"
        return "g@"
    end

    local line1, line2 = args[1], args[2]
    if not line1 then
        line1, line2 = vim.fn.line("'["), vim.fn.line("']")
    end

    vim.fn.VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
end

-- Function to open VSCode commands in visual mode
local function openVSCodeCommandsInVisualMode()
    vim.cmd("normal! gv")
    local visualmode = vim.fn.visualmode()
    if visualmode == "V" then
        local startLine, endLine = vim.fn.line("v"), vim.fn.line(".")
        vim.fn.VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        local startPos, endPos = vim.fn.getpos("v"), vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    end
end

-- Function to open WhichKey in visual mode
local function openWhichKeyInVisualMode()
    vim.cmd("normal! gv")
    local visualmode = vim.fn.visualmode()
    if visualmode == "V" then
        local startLine, endLine = vim.fn.line("v"), vim.fn.line(".")
        vim.fn.VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        local startPos, endPos = vim.fn.getpos("v"), vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    end
end

-- Key mappings
local opts = {
    noremap = true,
    silent = true
}

vim.api.nvim_set_keymap("n", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opts)
vim.api.nvim_set_keymap("x", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opts)
vim.api.nvim_set_keymap("x", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opts)
vim.api.nvim_set_keymap("x", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opts)
vim.api.nvim_set_keymap("x", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opts)

vim.api.nvim_set_keymap("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", opts)

vim.api.nvim_set_keymap("x", "<C-/>", "v:lua.vscodeCommentary()", {
    expr = true,
    noremap = true
})
vim.api.nvim_set_keymap("n", "<C-/>", 'v:lua.vscodeCommentary() . "_"', {
    expr = true,
    noremap = true
})

vim.api.nvim_set_keymap("n", "<C-w>_", ":<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>", opts)

vim.api.nvim_set_keymap("n", "<Space>", ":call VSCodeNotify('whichkey.show')<CR>", opts)
vim.api.nvim_set_keymap("x", "<Space>", ":<C-u>lua openWhichKeyInVisualMode()<CR>", opts)
vim.api.nvim_set_keymap("x", "<C-P>", ":<C-u>lua openVSCodeCommandsInVisualMode()<CR>", opts)

vim.api.nvim_set_keymap("x", "gc", "<Plug>VSCodeCommentary", {})
vim.api.nvim_set_keymap("n", "gc", "<Plug>VSCodeCommentary", {})
vim.api.nvim_set_keymap("o", "gc", "<Plug>VSCodeCommentary", {})
vim.api.nvim_set_keymap("n", "gcc", "<Plug>VSCodeCommentaryLine", {})
vim.api.nvim_set_keymap("n", "gC", ":call VSCodeNotify('editor.action.blockComment')<CR>", opts)
vim.api.nvim_set_keymap("x", "gC", ":call VSCodeNotify('editor.action.blockComment')<CR>", opts)

-- Simulate same TAB behavior in VSCode
vim.api.nvim_set_keymap("n", "<Tab>", ":Tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", ":Tabprev<CR>", opts)

-- Clipboard settings
vim.opt.clipboard = "unnamedplus"

-- Move selected lines up and down in visual mode
vim.api.nvim_set_keymap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)

-- Move current line up and down in normal mode
vim.api.nvim_set_keymap("n", "<C-j>", ":m .+1<CR>==", opts)
vim.api.nvim_set_keymap("n", "<C-k>", ":m .-2<CR>==", opts)

-- Add new line below the curosr.
-- vim.api.nvim_set_keymap("n", "<S-k>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<S-j>", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", opts)

-- Fold for nvim in vscode
local map = vim.api.nvim_set_keymap
local options = {
    noremap = true,
    silent = true
}

map("n", "za", '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>', options)
map("n", "zR", '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>', options)
map("n", "zM", '<Cmd>call VSCodeNotify("editor.foldAll")<CR>', options)
map("n", "zo", '<Cmd>call VSCodeNotify("editor.unfold")<CR>', options)
map("n", "zO", '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', options)
map("n", "zc", '<Cmd>call VSCodeNotify("editor.fold")<CR>', options)
map("n", "zC", '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', options)

map("n", "z1", '<Cmd>call VSCodeNotify("editor.foldLevel1")<CR>', options)
map("n", "z2", '<Cmd>call VSCodeNotify("editor.foldLevel2")<CR>', options)
map("n", "z3", '<Cmd>call VSCodeNotify("editor.foldLevel3")<CR>', options)
map("n", "z4", '<Cmd>call VSCodeNotify("editor.foldLevel4")<CR>', options)
map("n", "z5", '<Cmd>call VSCodeNotify("editor.foldLevel5")<CR>', options)
map("n", "z6", '<Cmd>call VSCodeNotify("editor.foldLevel6")<CR>', options)
map("n", "z7", '<Cmd>call VSCodeNotify("editor.foldLevel7")<CR>', options)

map("x", "zV", '<Cmd>call VSCodeNotify("editor.foldAllExcept")<CR>', options)

-- Next hunk
vim.api.nvim_set_keymap("n", "]c", '<Cmd>call VSCodeNotify("workbench.action.editor.nextChange")<CR>', {
    noremap = true,
    silent = true
})

-- Previous hunk
vim.api.nvim_set_keymap("n", "[c", '<Cmd>call VSCodeNotify("workbench.action.editor.previousChange")<CR>', {
    noremap = true,
    silent = true
})
