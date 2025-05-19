<?php
require 'config.php';

try {
    // Si $pdo está bien definido, esto imprimirá la versión de PostgreSQL
    $version = $pdo->query('SELECT version()')->fetchColumn();
    echo "Conexión exitosa a PostgreSQL:\n" . $version;
} catch (Exception $e) {
    echo "¡Error en la conexión! Mensaje:\n" . $e->getMessage();
}
