# Neovim Key Bindings

## General Key Bindings

- **Toggle Floaterm**
  - **Normal Mode**: `<S-C-t>` - Открыть или закрыть плавающее терминальное окно.
  - **Terminal Mode**: `<S-C-t>` - Открыть или закрыть плавающее терминальное окно.
  - **Normal Mode**: `<S-C-t>` - Open or close the floating terminal window.
  - **Terminal Mode**: `<S-C-t>` - Open or close the floating terminal window.

- **Toggle NERDTree**
  - **Normal Mode**: `,m` - Открыть или закрыть NERDTree.
  - **Normal Mode**: `,m` - Open or close NERDTree.

- **Buffer Navigation**
  - **Normal Mode**: `<C-h>` - Переключиться на предыдущий буфер.
  - **Normal Mode**: `<C-l>` - Переключиться на следующий буфер.
  - **Normal Mode**: `<C-h>` - Switch to the previous buffer.
  - **Normal Mode**: `<C-l>` - Switch to the next buffer.

- **Fold Navigation**
  - **Normal Mode**: `zR` - Открыть все свёртки.
  - **Normal Mode**: `zM` - Закрыть все свёртки.
  - **Normal Mode**: `zr` - Открыть все свёртки, кроме некоторых типов.
  - **Normal Mode**: `zm` - Закрыть все свёртки уровня 0.
  - **Normal Mode**: `K` - Показать содержимое свёртки под курсором или вызвать LSP hover.
  - **Normal Mode**: `<leader>zo` - Переключить свёртку под курсором.
  - **Normal Mode**: `zR` - Open all folds.
  - **Normal Mode**: `zM` - Close all folds.
  - **Normal Mode**: `zr` - Open all folds except certain kinds.
  - **Normal Mode**: `zm` - Close all folds with level 0.
  - **Normal Mode**: `K` - Peek at the folded lines under the cursor or show LSP hover.
  - **Normal Mode**: `<leader>zo` - Toggle the fold under the cursor.

- **Buffergator**
  - **Normal Mode**: `<leader>bg` - Открыть Buffergator.
  - **Normal Mode**: `<leader>bg` - Open Buffergator.

## Plugin Specific Key Bindings

### nvim-cmp

- **Scroll Documentation**
  - **Insert & Command Mode**: `<C-b>` - Прокрутить документацию вверх.
  - **Insert & Command Mode**: `<C-f>` - Прокрутить документацию вниз.
  - **Insert & Command Mode**: `<C-b>` - Scroll documentation up.
  - **Insert & Command Mode**: `<C-f>` - Scroll documentation down.

- **Complete**
  - **Insert & Command Mode**: `<C-Space>` - Вызвать автозавершение.
  - **Insert & Command Mode**: `<C-Space>` - Trigger completion.

- **Abort/Close Completion**
  - **Insert Mode**: `<C-e>` - Отменить автозавершение.
  - **Command Mode**: `<C-e>` - Закрыть автозавершение.
  - **Insert Mode**: `<C-e>` - Abort completion.
  - **Command Mode**: `<C-e>` - Close completion.

- **Confirm Completion**
  - **Insert Mode**: `<CR>` - Подтвердить выбор.
  - **Insert Mode**: `<CR>` - Confirm the selection.

- **Navigate Completion Menu**
  - **Insert & Select Mode**: `<Tab>` - Выбрать следующий элемент или развернуть сниппет.
  - **Insert & Select Mode**: `<S-Tab>` - Выбрать предыдущий элемент или вернуться в предыдущую позицию сниппета.
  - **Insert & Select Mode**: `<Tab>` - Select the next item or expand snippet.
  - **Insert & Select Mode**: `<S-Tab>` - Select the previous item or jump back in snippet.

### ufo (Folding Plugin)

- **Open all folds**
  - **Normal Mode**: `zR` - Открыть все свёртки.
  - **Normal Mode**: `zR` - Open all folds.

- **Close all folds**
  - **Normal Mode**: `zM` - Закрыть все свёртки.
  - **Normal Mode**: `zM` - Close all folds.

- **Open folds except certain kinds**
  - **Normal Mode**: `zr` - Открыть все свёртки, кроме определённых типов.
  - **Normal Mode**: `zr` - Open folds except certain kinds.

- **Close folds with level 0**
  - **Normal Mode**: `zm` - Закрыть все свёртки уровня 0.
  - **Normal Mode**: `zm` - Close folds with level 0.

- **Peek folded lines under cursor**
  - **Normal Mode**: `K` - Показать содержимое свёртки под курсором или вызвать LSP hover.
  - **Normal Mode**: `K` - Peek at the folded lines under the cursor or show LSP hover.

- **Toggle specific fold under cursor**
  - **Normal Mode**: `<leader>zo` - Переключить свёртку под курсором.
  - **Normal Mode**: `<leader>zo` - Toggle the fold under the cursor.

## Additional Configuration

- **Transparent Background**
  - **Normal Mode**: `highlight Normal ctermbg=none guibg=none` - Сделать фон прозрачным.
  - **Normal Mode**: `highlight NonText ctermbg=none guibg=none` - Сделать фон прозрачным для не текстовых символов.
  - **Normal Mode**: `highlight Normal ctermbg=none guibg=none` - Make the background transparent.
  - **Normal Mode**: `highlight NonText ctermbg=none guibg=none` - Make the background transparent for non-text symbols.

