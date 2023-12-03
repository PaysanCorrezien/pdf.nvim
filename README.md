# pdf.nvim

A Simple tool to convert pdf pages on images quickly on markdown document.

`pdf.nvim` is a NeoVim plugin designed to convert PDF files to images within NeoVim. It provides a convenient way to process PDF files directly from your editor, leveraging `pdftoppm` for conversion.

## Prerequisites

- NeoVim (0.( or later)
- `pdftoppm` command-line utility that is included in `poppler` software [Poppler](https://poppler.freedesktop.org/)

## Installation

### Using Lazy

```lua
{
  "paysancorrezien/pdf.nvim",
		ft = "markdown",
    dependencies = {
			"nvim-lua/plenary.nvim",
    },
  config = function()
    require("pdf").setup({
      pdf_path = "~/Obsidian/Vault/Files/",
      image_path = "~/Obsidian/Vault/Images/",
      pdftoppm_path = "/usr/bin/pdftoppm",
      link_pattern = "(.-)%[(.-)%]%((.-)%.pdf#page=(%d+)%)",
      new_link_format = function(prefix, text, generated_image_file)
        return prefix .. "[" .. text .. "](" .. generated_image_file .. ")"
      end,
      -- Add any other configuration options here
    })
  end,
}
```

## Configuration

All the configuration options are configured on previous setup

### Available Configuration Settings

- `pdf_path`: The path to your PDF files. Default: `"/path/to/pdf/"`
- `image_path`: The path where the converted images should be stored. Default: `"/path/to/images/"`
- `pdftoppm_path`: The path to the `pdftoppm` utility. Default: `"/usr/bin/pdftoppm"`
- `link_pattern`: The Lua pattern used to identify PDF links in your files. Default: `"(.-)%[(.-)%]%((.-)%.pdf#page=(%d+)%)"`
- `new_link_format`: A function to format the new link after conversion. Accepts `prefix`, `text`, and `generated_image_file` as arguments.

## Usage

Once configured, you can use the following command in NeoVim to convert a PDF link to an image on the current line:

When you are on a line with a link like this `[apdf](pdfname.pdf#page=10)`

```vim
:ConvertPdfToImg
```

This will convert the specific page to an image, put it in defined directory and replace the pdf link with the image link.

### Misc

To check that the settings are correctly applied :

```vim
:lua require('pdf').conf()
```

---
