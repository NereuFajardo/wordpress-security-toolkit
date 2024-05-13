#!/bin/bash

# Encontra todos os arquivos wp-config.php
find / -name wp-config.php 2>/dev/null | while read config_file
do
    echo "Atualizando as keys no arquivo: $config_file"

    # Cria um backup do arquivo wp-config.php
    cp $config_file "${config_file}.bak"

    # Deleta as chaves antigas
    sed -i '/define(.*AUTH_KEY/d' $config_file
    sed -i '/define(.*SECURE_AUTH_KEY/d' $config_file
    sed -i '/define(.*LOGGED_IN_KEY/d' $config_file
    sed -i '/define(.*NONCE_KEY/d' $config_file
    sed -i '/define(.*AUTH_SALT/d' $config_file
    sed -i '/define(.*SECURE_AUTH_SALT/d' $config_file
    sed -i '/define(.*LOGGED_IN_SALT/d' $config_file
    sed -i '/define(.*NONCE_SALT/d' $config_file

    # Busca novas salt keys da API do WordPress
    new_keys=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

    # Verifica se recebeu as novas keys
    if [ -z "$new_keys" ]; then
        echo "Falha ao obter novas keys para o arquivo: $config_file"
        continue  # Pula para o próximo arquivo se falhar em obter as keys
    fi

    # Adiciona as novas chaves
    echo "$new_keys" >> $config_file

    echo "Keys atualizadas com sucesso em: $config_file"
done

echo "Atualização das keys concluída em todos os arquivos encontrados."
