#!/bin/bash

# Encontra todos os arquivos wp-config.php
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

    # Substitui as chaves antigas pelas novas chaves no arquivo
    awk -v new_keys="$new_keys" '
        /define\(.*AUTH_KEY/ {$0 = "define('AUTH_KEY', '" new_keys "');"}
        /define\(.*SECURE_AUTH_KEY/ {$0 = "define('SECURE_AUTH_KEY', '" new_keys "');"}
        /define\(.*LOGGED_IN_KEY/ {$0 = "define('LOGGED_IN_KEY', '" new_keys "');"}
        /define\(.*NONCE_KEY/ {$0 = "define('NONCE_KEY', '" new_keys "');"}
        /define\(.*AUTH_SALT/ {$0 = "define('AUTH_SALT', '" new_keys "');"}
        /define\(.*SECURE_AUTH_SALT/ {$0 = "define('SECURE_AUTH_SALT', '" new_keys "');"}
        /define\(.*LOGGED_IN_SALT/ {$0 = "define('LOGGED_IN_SALT', '" new_keys "');"}
        /define\(.*NONCE_SALT/ {$0 = "define('NONCE_SALT', '" new_keys "');"}
        {print}
    ' $config_file > temp_file && mv temp_file $config_file

    echo "Keys atualizadas com sucesso em: $config_file"
done

echo "Atualização das keys concluída em todos os arquivos encontrados."
