# ==============================================================================
# Script: Organizar_Downloads.ps1
# Descrição: Organiza automaticamente a pasta de Downloads do Windows por categorias.
# ==============================================================================

# 1. Navega até a pasta de Downloads do usuário logado
cd $HOME\Downloads

# 2. Define a lista de pastas que precisam existir
$pastas = @("Imagens", "Documentos", "Videos", "Musicas", "Compactados", "Instaladores", "Outros")

# 3. Cria as pastas caso elas ainda não existam
foreach ($pasta in $pastas) { 
    if (!(Test-Path $pasta)) { 
        New-Item -ItemType Directory -Name $pasta | Out-Null
    } 
}

# 4. Varre todos os arquivos soltos na raiz da pasta Downloads
Get-ChildItem -File | ForEach-Object {
    $ext = $_.Extension.ToLower()
    $destino = $null
    
    # 5. Classifica o arquivo com base na sua extensão
    switch ($ext) {
        { $_ -in '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg' } { $destino = "Imagens" }
        { $_ -in '.pdf', '.docx', '.doc', '.xlsx', '.xls', '.pptx', '.txt', '.csv' } { $destino = "Documentos" }
        { $_ -in '.mp4', '.mkv', '.avi', '.mov', '.wmv' } { $destino = "Videos" }
        { $_ -in '.mp3', '.wav', '.flac', '.m4a' } { $destino = "Musicas" }
        { $_ -in '.zip', '.rar', '.7z', '.tar', '.gz' } { $destino = "Compactados" }
        { $_ -in '.exe', '.msi' } { $destino = "Instaladores" }
        default { $destino = "Outros" } # Tudo o que não se encaixar acima vai para cá
    }
    
    # 6. Move o arquivo para a pasta de destino correspondente
    if ($destino) { 
        Move-Item -Path $_.FullName -Destination $destino -Force 
    }
}
