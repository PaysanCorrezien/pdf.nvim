-- init.lua
local Job = require'plenary.job'
-- TODO: Commencer le projet
--
local M = {}
local home = os.getenv("HOME") or "~"
-- Define the paths directly using the home directory path
vim.g.my_ltexfile_path = home .. "/.local/share/chezmoi/dot_config/lvim/dict/ltex.dictionary.fr.txt"

M.config = {
	pdf_path = home .. "/Documents/pdf/",
	image_path = home .. "/Documents/images",
	pdftoppm_path = "/usr/bin/pdftoppm",
	link_pattern = "(.-)%[(.-)%]%((.-)%.pdf#page=(%d+)%)",
	new_link_format = function(prefix, text, generated_image_file)
		return prefix .. "[" .. text .. "](" .. generated_image_file .. ")"
	end,
}

function M.setup(user_config)
	M.config = vim.tbl_extend("force", M.config, user_config)
	-- require("pdf.autocommands").setup(M.config)
end

function M.conf()
	print("Hello from pdfnvim!")
	for k, v in pairs(M.config) do
		print(k, v)
	end
end

function M.PdfToImage()
    local line = vim.api.nvim_get_current_line()
    local prefix, text, pdf_file, page_number = string.match(line, M.config.link_pattern)

    if pdf_file and page_number then
        local full_pdf_path = M.config.pdf_path .. pdf_file .. ".pdf"
        local formatted_page_number = tonumber(page_number) < 10 and "0" .. page_number or page_number
        local output_image_prefix = M.config.image_path .. pdf_file
        local generated_image_file = pdf_file .. "-" .. formatted_page_number .. ".jpg"

        Job:new({
            command = M.config.pdftoppm_path,
            args = { '-f', tostring(page_number), '-l', tostring(page_number), '-jpeg', full_pdf_path, output_image_prefix },
            cwd = vim.loop.cwd(),
            on_exit = function(j, return_val)
                local output = j:result()
                if return_val == 0 and #output == 0 then
                    print("File converted successfully: " .. generated_image_file)
                    vim.schedule(function()
                        local new_link = M.config.new_link_format(prefix, text, generated_image_file)
                        vim.api.nvim_set_current_line(new_link)
                    end)
                else
                    print("Error converting file: ", table.concat(output, '\n'))
                end
            end,
        }):start()
    else
        print("No suitable link found on the current line.")
    end
end


-- Expose the command to the user
vim.cmd("command! ConvertPdfToImg lua require('pdf').PdfToImage()")
-- vim.cmd("command! PDFConf :lua require('pdf').conf()")

return M
