<?php
// Incluimos la configuración de la conexión (define $pdo)
require 'config.php';

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Recogemos y saneamos datos
    $nombre = trim($_POST["nombre"]);
    $nota1  = floatval($_POST["nota1"]);
    $nota2  = floatval($_POST["nota2"]);
    $nota3  = floatval($_POST["nota3"]);

    // Calculamos la nota final
    $nota_final = round($nota1 * 0.3 + $nota2 * 0.3 + $nota3 * 0.4, 2);

    // Preparamos la inserción usando PDO y parámetros nombrados
    $sql = "INSERT INTO notas (nombre, nota1, nota2, nota3, nota_final)
            VALUES (:nombre, :n1, :n2, :n3, :final)";
    $stmt = $pdo->prepare($sql);

    try {
        $stmt->execute([
            ':nombre' => $nombre,
            ':n1'      => $nota1,
            ':n2'      => $nota2,
            ':n3'      => $nota3,
            ':final'   => $nota_final
        ]);
        $mensaje = "Registro guardado correctamente.";
    } catch (PDOException $e) {
        $mensaje = "Error al guardar en la base de datos: " . $e->getMessage();
    }
}

// Si llega el parámetro ?action=ver, se muestran los registros
if (isset($_GET['action']) && $_GET['action'] === 'ver') {
    $mostrarModal = true;

    try {
        $stmt = $pdo->query("SELECT * FROM notas ORDER BY fecha DESC");
        $notas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        $mensaje = "Error al obtener registros: " . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Calculadora de Notas</title>
    <link rel="stylesheet" href="styles.css" />
</head>
<body>
    <!-- contenido normal -->

<?php if (isset($mensaje)): ?>
    <div class="mensaje"><?= htmlspecialchars($mensaje) ?></div>
<?php endif; ?>

<form method="post" action="">
    <label>
        Nombre del estudiante:
        <input type="text" name="nombre" required />
    </label>
    <label>
        Nota 1 (30%):
        <input type="number" name="nota1" step="0.01" min="0" max="5" required />
    </label>
    <label>
        Nota 2 (30%):
        <input type="number" name="nota2" step="0.01" min="0" max="5" required />
    </label>
    <label>
        Nota 3 (40%):
        <input type="number" name="nota3" step="0.01" min="0" max="5" required />
    </label>
    <button type="submit">Calcular y Guardar</button>
</form>

    <!-- Botón para mostrar tabla en modal -->
    <form method="get" action="" style="margin-top: 1.5rem; text-align: center;">
        <button type="submit" name="action" value="ver" style="background: var(--color-secundario); color: white; border:none; padding: 0.6rem 1.2rem; font-weight: 600; border-radius: 8px; cursor: pointer; transition: background-color 0.3s ease;">
            Ver todas las notas
        </button>
    </form>

    <?php if ($mostrarModal): ?>
        <div class="modal-overlay" id="modal">
            <div class="modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
                <span class="close-modal" id="closeModal" title="Cerrar">&times;</span>
                <h2 id="modalTitle">Registros de Notas</h2>

                <?php if (count($notas) === 0): ?>
                    <p>No hay registros para mostrar.</p>
                <?php else: ?>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Nota 1</th>
                                <th>Nota 2</th>
                                <th>Nota 3</th>
                                <th>Nota Final</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($notas as $nota): ?>
                                <tr>
                                    <td><?= htmlspecialchars($nota['id']) ?></td>
                                    <td><?= htmlspecialchars($nota['nombre']) ?></td>
                                    <td><?= htmlspecialchars($nota['nota1']) ?></td>
                                    <td><?= htmlspecialchars($nota['nota2']) ?></td>
                                    <td><?= htmlspecialchars($nota['nota3']) ?></td>
                                    <td><?= htmlspecialchars($nota['nota_final']) ?></td>
                                    <td><?= htmlspecialchars($nota['fecha']) ?></td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                <?php endif; ?>
            </div>
        </div>

        <script>
            // Cerrar modal al hacer click en la X o fuera del modal
            const modal = document.getElementById('modal');
            const closeModalBtn = document.getElementById('closeModal');

            closeModalBtn.addEventListener('click', () => {
                window.history.replaceState(null, '', window.location.pathname); // Quitar ?action=ver sin recargar
                modal.style.display = 'none';
            });

            modal.addEventListener('click', e => {
                if (e.target === modal) {
                    window.history.replaceState(null, '', window.location.pathname);
                    modal.style.display = 'none';
                }
            });
        </script>
    <?php endif; ?>
</body>
</html>
