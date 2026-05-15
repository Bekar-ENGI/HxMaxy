local M = {}

-- Void (self-closing) HTML tags
local void_tags = {
    area=true, base=true, br=true, col=true, embed=true,
    hr=true, img=true, input=true, link=true, meta=true,
    param=true, source=true, track=true, wbr=true
}

-- Check if closing tag already exists ahead
local function has_closing_tag_ahead(tag)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, row - 1, row + 5, false)

    for _, l in ipairs(lines) do
        if l:find("</" .. tag .. ">") then
            return true
        end
    end
    return false
end

-- Main logic
function M.auto_close_tag()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    local before = line:sub(1, col)

    -- Ignore JSX expressions like { <div> }
    if before:match("{[^}]*$") then
        return
    end

    -- Match tag (supports attributes)
    local tag = before:match("<([%w:_-]+)[^>]*>$")
    if not tag then return end

    -- Ignore void tags and self-closing syntax
    if void_tags[tag] or before:match("/%s*>$") then
        return
    end

    -- Avoid duplicate closing tags
    if has_closing_tag_ahead(tag) then
        return
    end

    -- Insert closing tag
    vim.api.nvim_put({ "</" .. tag .. ">" }, "c", true, true)

    -- Restore cursor inside
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
end

-- Setup (correct mapping)
function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "xml", "javascriptreact", "typescriptreact" },
        callback = function()
            vim.keymap.set("i", ">", function()
                vim.schedule(function()
                    M.auto_close_tag()
                end)
                return ">"
            end, { buffer = true, expr = true })
        end
    })
end

return M
