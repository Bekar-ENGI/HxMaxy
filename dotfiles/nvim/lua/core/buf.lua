vim.keymap.set("n", "<A-l>", function()

    local function open_buffer_popup()

        local buf = vim.api.nvim_create_buf(false, true)
        local all_bufs = vim.api.nvim_list_bufs()
        local current = vim.api.nvim_get_current_buf()
        local alternate = vim.fn.bufnr("#")

        local lines = {}
        local buffer_map = {}

        -- Banner
        table.insert(lines, " Buffers ")
        table.insert(lines, string.rep("─", 50))

        for _, b in ipairs(all_bufs) do
            if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
                local name = vim.api.nvim_buf_get_name(b)
                name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"

                local symbol = " "

                if b == current then
                    symbol = "%"
                elseif b == alternate then
                    symbol = "#"
                end

                if vim.bo[b].modified then
                    symbol = symbol .. "+"
                end

                local line = string.format(" %s  %s", symbol, name)
                table.insert(lines, line)

                buffer_map[#lines] = b
            end
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local width = math.floor(vim.o.columns * 0.5)
        local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.6))

        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
        })

        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].modifiable = false

        vim.api.nvim_win_set_cursor(win, {3, 0})

        -- ENTER -> open buffer
        vim.keymap.set("n", "<CR>", function()
            local line = vim.api.nvim_win_get_cursor(win)[1]
            local selected = buffer_map[line]
            if selected then
                vim.api.nvim_win_close(win, true)
                vim.api.nvim_set_current_buf(selected)
            end
        end, { buffer = buf })

        -- d → smart delete buffer
        vim.keymap.set("n", "d", function()
            local line = vim.api.nvim_win_get_cursor(win)[1]
            local selected = buffer_map[line]
            if not selected then return end

            local current_buf = vim.api.nvim_get_current_buf()

            -- If deleting current buffer, switch first
            if selected == current_buf then
                local alt = vim.fn.bufnr("#")

                -- Try alternate buffer
                if alt > 0 and vim.api.nvim_buf_is_loaded(alt) and vim.bo[alt].buflisted then
                    vim.api.nvim_set_current_buf(alt)
                else
                    -- Fallback: switch to any other listed buffer
                    for _, b in pairs(buffer_map) do
                        if b ~= selected and vim.api.nvim_buf_is_loaded(b) then
                            vim.api.nvim_set_current_buf(b)
                            break
                        end
                    end
                end
            end

            -- Delete buffer
            vim.api.nvim_buf_delete(selected, { force = false })

            -- Refresh popup
            vim.api.nvim_win_close(win, true)
            open_buffer_popup()

        end, { buffer = buf })

        -- q → close
        vim.keymap.set("n", "q", function()
            vim.api.nvim_win_close(win, true)
        end, { buffer = buf })

    end

    open_buffer_popup()

end)

-- buffer navigations
-- Navigate to next buffer with Alt + Right
vim.keymap.set('n', '<A-Right>', '<CMD>bnext<CR>', { noremap = true, silent = true })

-- Navigate to previous buffer with Alt + Left
vim.keymap.set('n', '<A-Left>', '<CMD>bprevious<CR>', { noremap = true, silent = true })
