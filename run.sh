#!/bin/bash

# Define o nome e local do repositório
repo_name="wordpress-security-toolkit"
repo_url="https://github.com/NereuFajardo/$repo_name.git"
repo_path="./$repo_name"

# Clona o repositório se não existir
if [ ! -d "$repo_path" ]; then
    echo "Clonando o repositório $repo_name..."
    git clone $repo_url
    cd $repo_name
else
    # Entra no diretório do repositório
    cd $repo_path

    # Reseta quaisquer mudanças locais e puxa as últimas atualizações do repositório
    echo "Reseteando mudanças locais e atualizando o repositório $repo_name..."
    git reset --hard HEAD
    git pull origin main
fi

# Garante que todos os scripts na subpasta 'scripts' são executáveis
chmod +x scripts/*.sh

# Executa todos os scripts dentro da subpasta 'scripts'
for script in scripts/*.sh; do
    if [ -x "$script" ]; then
        echo "Executando $script..."
        ./$script
    else
        echo "Ignorando arquivo não executável: $script"
    fi
done

echo "Todos os scripts foram executados."
