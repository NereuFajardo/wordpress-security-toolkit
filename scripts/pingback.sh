#!/bin/bash

# Encontra todos os arquivos wp-config.php
find / -name wp-config.php 2>/dev/null | while read config_file
do
    echo "Verificando $config_file..."

    # Verifica se o arquivo wp-config.php existe
    if [ -f "$config_file" ]; then
        echo "Verificando $config_file..."

        # Verifica se as funções já estão presentes no arquivo
        if grep -q "// remove x-pingback HTTP header" "$config_file" && grep -q "add_filter('wp_headers'" "$config_file" && grep -q "// disable pingbacks" "$config_file" && grep -q "add_filter( 'xmlrpc_methods'" "$config_file"; then
            echo "As funções X-pingback já estão presentes em $config_file"
        else
            echo "Adicionando funções X-pingback em $config_file"

            # Adiciona as funções no arquivo wp-config.php
            cat <<EOT >> "$config_file"
// remove x-pingback HTTP header
add_filter('wp_headers', function(\$headers) {
    unset(\$headers['X-pingback']);
    return \$headers;
});

// disable pingbacks
add_filter( 'xmlrpc_methods', function( \$methods ) {
    unset( \$methods['pingback.ping'] );
    return \$methods;
});
EOT
            echo "As funções X-pingback foram adicionadas com sucesso em $config_file"
        fi
    else
        echo "Arquivo wp-config.php não encontrado em $config_file"
    fi
done

echo "Verificação e adição de funções X-pingback concluídas em todos os arquivos encontrados."
