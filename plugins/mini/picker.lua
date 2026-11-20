return function()
    local pick = require("mini.pick")
    pick.setup({
        window = {
            config = function()
                local width = math.min(100, math.floor(0.618 * vim.o.columns))
                return { width = width, col = math.floor(0.5 * (vim.o.columns - width)) }
            end,
        },
    })
    vim.ui.select = pick.ui_select
    require("mini.visits").setup()

    local ns_id = vim.api.nvim_create_namespace("MiniPick FFFiles Picker")

    local function current_file(cwd)
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or vim.fn.filereadable(path) == 0 then return nil end
        return vim.fs.relpath(cwd, path) or path
    end

    local current_file_cache

    local function find(query)
        local cwd = vim.fn.getcwd()
        local result = require("fff").file_search(query or "", {
            max_results = 100,
            current_file = current_file_cache,
            cwd = cwd,
        })

        local items = {}
        for _, file in ipairs(result.items) do
            items[#items + 1] = {
                text = file.relative_path,
                path = vim.fs.joinpath(cwd, file.relative_path),
            }
        end
        return items
    end

    local function show(buf_id, items)
        local icon_data = {}
        local lines = {}

        for i, item in ipairs(items) do
            local icon, hl = require("mini.icons").get("file", item.text)
            icon_data[i] = { icon = icon, hl = hl }
            lines[i] = string.format("%s %s", icon, item.text)
        end
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
        vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)

        local extmark_opts = { hl_mode = "combine", priority = 200 }
        for i = 1, #items do
            local icon = icon_data[i].icon
            extmark_opts.hl_group = icon_data[i].hl
            extmark_opts.end_row, extmark_opts.end_col = i - 1, #icon
            vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, extmark_opts)
        end
    end

    local function run()
        current_file_cache = current_file(vim.fn.getcwd())
        pick.start({
            source = {
                name = "FFFiles",
                items = find,
                match = function(_, _, query)
                    pick.set_picker_items(find(table.concat(query)), { do_match = false })
                end,
                show = show,
            },
        })
        current_file_cache = nil
    end

    pick.registry.fffiles = run
    pick.registry.files = run

    local map = vim.keymap.set
    map("n", "<leader>f", run, { desc = "Find files" })
    map("n", "<leader>F", function() pick.builtin.grep_live() end, { desc = "Live grep" })
    map("n", "<leader>pg", function() pick.builtin.grep() end, { desc = "Grep" })
    map("n", "<leader>pb", function() pick.builtin.buffers() end, { desc = "Buffers" })
    map("n", "<leader>ph", function() pick.builtin.help() end, { desc = "Help" })
    map("n", "<leader>pc", function() require("mini.extra").pickers.commands() end, { desc = "Commands" })
    map("n", "<leader>pk", function() require("mini.extra").pickers.keymaps() end, { desc = "Keymaps" })
    map("n", "<leader>po", function() require("mini.extra").pickers.oldfiles() end, { desc = "Old files" })
    map("n", "<leader>pv", function() require("mini.extra").pickers.visit_paths() end, { desc = "Frecency visits" })
    map("n", "<leader>pR", function() pick.builtin.resume() end, { desc = "Resume picker" })
    map("n", "<leader>pd", function() require("mini.extra").pickers.diagnostic() end, { desc = "Diagnostics" })
end
