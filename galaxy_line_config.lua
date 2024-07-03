local gl = require('galaxyline')
local gps = require('nvim-gps')
local gls = gl.section
local extension = require('galaxyline.provider_extensions')
local dap = require('dap')

gl.short_line_list = {
    'LuaTree',
    'NvimTree',
    'vista',
    'dbui',
    'startify',
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug',
    'plugins'
}

VistaPlugin = extension.vista_nearest

local ProgFileTypes = {'lua', 'python', 'typescript', 'typescriptreact', 'react', 'javascript', 'javascriptreact', 'rust', 'go', 'html'}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function get_color()
    if vim.o.background == 'light' then
        return "#fff"
    end
    return "#353644"
end

local function get_color_bg()
    if vim.o.background == 'light' then
        return "#fff"
    end
    return "#282c34"
end

local colors = {
    bg = "#282c34",
    line_bg = get_color_bg(),
    fg = '#8FBCBB',
    fg_green = '#65a380',
    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67'
}

local function file_readonly(readonly_icon)
  if vim.bo.filetype == 'help' then
    return ''
  end
  local icon = readonly_icon or ''
  if vim.bo.readonly == true then
    return " " .. icon .. " "
  end
  return ''
end

local function get_current_file_name()
  local file = vim.fn.expand('%:f')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly(readonly_icon)) ~= 0 then
    return file .. file_readonly(readonly_icon)
  end
  local icon = modified_icon or ''
  if vim.bo.modifiable then
    if vim.bo.modified then
      return file .. ' ' .. icon .. '  '
    end
  end
  return file .. ' '
end

local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end

local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  return lsp_status(status)
end

local function get_debug_status()
  local status = dap.status()
  if not status or status == '' then
      return ''
  end
  return  '  ' .. status
end

function get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
  end
  return ''
end

local function get_current_func()
  local has_func, func_name = pcall(vim.api.nvim_buf_get_var, 0, 'coc_current_function')
  if not has_func then return end
      return func_name
end

function get_function_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_current_func()
  end
  return ''
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

CocStatus = get_diagnostic_info
DebugInfo = get_debug_status
CocFunc = get_current_func
TrailingWhiteSpace = trailing_whitespace

function has_file_type()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    return true
end

function has_file_prog_filetype()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    if has_value(ProgFileTypes, f_type) then
        return true
    end
    return false
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  FirstElement = {
    provider = function() return ' ' end,
    highlight = {colors.blue, colors.line_bg}
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          c= 'COMMAND',
          V= 'VISUAL',
          [''] = 'VISUAL',
          v = 'VISUAL',
          c = 'COMMAND-LINE',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R = 'REPLACE',
          Rv = 'VIRTUAL',
          s = 'SELECT',
          S = 'SELECT',
          ['r'] = 'HIT-ENTER',
          [''] = 'SELECT',
          t = 'TERMINAL',
          ['!'] = 'SHELL',
      }
      local mode_color = {
          n = colors.green,
          i = colors.blue,
          v = colors.magenta,
          [''] = colors.blue,
          V = colors.blue,
          c = colors.red,
          no = colors.magenta,
          s = colors.orange,
          S = colors.orange,
          [''] = colors.orange,
          ic = colors.yellow,
          R = colors.purple,
          Rv = colors.purple,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ['r?'] = colors.cyan,
          ['!'] = colors.green,
          t = colors.green,
          c = colors.purple,
          ['r?'] = colors.red,
          ['r'] = colors.red,
          rm = colors.red,
          R = colors.yellow,
          Rv = colors.magenta,
      }
      local vim_mode = vim.fn.mode()
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode])
      return alias[vim_mode] .. '   '
    end,
    highlight = {colors.red, colors.line_bg, 'bold'},
  },
}
gls.left[3] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.line_bg},
  },
}
gls.left[4] = {
  FileName = {
    provider = {get_current_file_name, 'FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.fg, colors.line_bg, 'bold'}
  }
}
gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.yellow, colors.line_bg},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.yellow, colors.line_bg, 'bold'},
  }
}
local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end
gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '   ',
    highlight = {colors.green, colors.line_bg},
  }
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '   ',
    highlight = {colors.orange, colors.line_bg},
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '   ',
    highlight = {colors.red, colors.line_bg},
  }
}
gls.left[10] = {
  TrailingWhiteSpace = {
    provider = TrailingWhiteSpace,
    icon = '   ',
    highlight = {colors.yellow, colors.bg},
  }
}
gls.left[11] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red, colors.bg}
  }
}
gls.left[12] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '   ',
    highlight = {colors.yellow, colors.bg},
  }
}
gls.left[13] = {
  CocStatus = {
    provider = CocStatus,
    highlight = {colors.green, colors.bg},
    icon = '   '
  }
}
gls.left[14] = {
  nvimGPS = {
    provider = function()
      return gps.get_location()
    end,
    condition = function()
      return gps.is_available()
    end,
    icon = '  ',
    highlight = {colors.yellow, colors.bg},
  }
}
gls.right[1] = {
  TelescopePrompt = {
    provider = function()
      return vim.g.telescope_status or ''
    end,
    highlight = {colors.orange, colors.bg}
  }
}
gls.right[2] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {colors.bg, colors.line_bg},
    highlight = {colors.fg, colors.line_bg, 'bold'},
  }
}
gls.right[3] = {
  Debug = {
    provider = DebugInfo,
    separator = ' ',
    separator_highlight = {colors.blue, colors.line_bg},
    highlight = {colors.red, colors.line_bg, 'bold'},
  }
}
gls.right[4] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.blue, colors.line_bg},
    highlight = {colors.fg, colors.line_bg},
  },
}
gls.right[5] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.line_bg, colors.line_bg},
    highlight = {colors.cyan, colors.darkblue, 'bold'},
  }
}
gls.right[6] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.yellow, colors.purple},
  }
}
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.fg, colors.purple}
  }
}
gls.short_line_right[1] = {
  BufferIcon = {
    provider = 'BufferIcon',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.fg, colors.purple}
  }
}

-- Auto command to reload galaxyline
vim.cmd([[
  augroup galaxyline_user_events
    autocmd!
    autocmd BufEnter,BufWinEnter,TabEnter,InsertLeave * lua require('galaxyline').load_galaxyline()
  augroup END
]])

