#!/bin/bash

# Encontra todos os arquivos wp-config.php no sistema
find / -name wp-config.php 2>/dev/null | while read config_file
do
    echo "Atualizando as keys no arquivo: $config_file"

    # Cria um backup do arquivo wp-config.php
    cp $config_file "${config_file}.bak"

    # Busca novas salt keys da API do WordPress
    new_keys=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

    # Verifica se recebeu as novas keys
    if [ -z "$new_keys" ]; then
        echo "Falha ao obter novas keys para o arquivo: $config_file"
        continue  # Pula para o próximo arquivo se falhar em obter as keys
    fi

    # Cria um novo arquivo temporário com as chaves atualizadas
    awk -v new_keys="$new_keys" '
        /define\(.*AUTH_KEY/ {print new_keys; next}
        /define\(.*SECURE_AUTH_KEY/ {next}
        /define\(.*LOGGED_IN_KEY/ {next}
        /define\(.*NONCE_KEY/ {next}
        /define\(.*AUTH_SALT/ {next}
        /define\(.*SECURE_AUTH_SALT/ {next}
        /define\(.*LOGGED_IN_SALT/ {next}
        /define\(.*NONCE_SALT/ {next}
        {print}
    ' $config_file > temp_file && mv temp_file $config_file

    echo "Keys atualizadas com sucesso em: $config_file"
done

echo "Atualização das keys concluída em todos os arquivos encontrados."
