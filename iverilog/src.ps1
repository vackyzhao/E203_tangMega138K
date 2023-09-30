# 获取当前目录路径
$currentDirectory = Get-Location

# 获取所有 .v 文件的相对路径并格式化输出
$verilogFiles = Get-ChildItem -Recurse -File -Include *.v | ForEach-Object { $_.FullName -replace [regex]::Escape($currentDirectory), '.' }
$verilogFiles = $verilogFiles -replace '^\.\\', ''

# 格式化输出，并将文件路径保存到文本文件
$verilogFiles -join ' ' | Out-File "verilog_filepaths_space_separated.txt"
