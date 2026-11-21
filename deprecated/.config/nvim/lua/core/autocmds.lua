vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local bufs = vim.api.nvim_list_bufs()
    if #bufs > 1 then
      for _, bufnr in ipairs(bufs) do
        -- Kiểm tra nếu buffer trống, không có tên và chưa được sửa đổi
        if vim.api.nvim_buf_get_name(bufnr) == "" 
           and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == "" 
           and vim.api.nvim_buf_line_count(bufnr) == 1 
           and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == "" 
           and not vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})
