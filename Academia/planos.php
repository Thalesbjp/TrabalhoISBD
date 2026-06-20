<?php
include __DIR__ . '/db.php';
$con = db_connect();
$message = isset($_GET['message']) ? htmlspecialchars($_GET['message'], ENT_QUOTES, 'UTF-8') : null;
$sql = "SELECT idPlano, nomePlano, valor FROM Plano ORDER BY idPlano";
$result = mysqli_query($con, $sql);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Planos</title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } table { border-collapse: collapse; width: 100%; } th, td { border: 1px solid #888; padding: 8px; text-align: left; } th { background: #ddd; }</style>
</head>
<body>
    <h1>Planos</h1>
    <?php if ($message): ?>
        <p style="color: green;"><?php echo $message; ?></p>
    <?php endif; ?>
    <p><a href="plano_form.php">Cadastrar novo plano</a></p>
    <table>
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Valor</th>
            <th>Ações</th>
        </tr>
        <?php while ($row = mysqli_fetch_assoc($result)): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['idPlano'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['nomePlano'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>R$ <?php echo number_format($row['valor'], 2, ',', '.'); ?></td>
                <td>
                    <a href="plano_form.php?idPlano=<?php echo urlencode($row['idPlano']); ?>">Editar</a> |
                    <a href="plano_excluir.php?idPlano=<?php echo urlencode($row['idPlano']); ?>" onclick="return confirm('Deseja excluir este plano?');">Excluir</a>
                </td>
            </tr>
        <?php endwhile; ?>
    </table>
    <p><a href="index.php">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
