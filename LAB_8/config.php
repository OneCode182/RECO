<?php
// Parámetros de conexión
$host = 'localhost';
$db   = 'notas_db';
$user = 'estudiante';
$pass = 'pass123$';
$dsn  = "pgsql:host=$host;dbname=$db";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
?>
