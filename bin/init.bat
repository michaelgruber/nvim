@Echo Off

set "src=%~dp0..\init.vim"
set "dest=%HOMEPATH%\AppData\Local\nvim"

rmdir /s /q %HOMEPATH%\.dein
mkdir %dest%

git clone "git@github.com:Shougo/dein.vim.git" %HOMEPATH%\.dein\repos\github.com\Shougo\dein.vim

del %dest%\init.vim
mklink %dest%\init.vim %src%
