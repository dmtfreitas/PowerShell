# CONTA A QUANTIDADE DE ARQUIVOS COM EXTENSÃO PDF EXISTENTES NO DIRETÓRIO ATUAL E SUBDIRETÓRIOS TAMBÉM, CONSIDERANDO SOMENTE ARQUIVOS MODIFICADOS ENTRE O INÍCIO DO MÊS E A DATA/HORA ATUAL

$filePath = $PWD.Path
$fileExtension = '*.py'
$startMonth = Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0
$now = Get-Date

(Get-ChildItem "$filePath\$fileExtension" -Recurse | Where-Object {
    $_.LastWriteTime -ge $startMonth -and
    $_.LastWriteTime -lt $now
}).Count