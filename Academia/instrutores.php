<?php
include __DIR__ . '/db.php';
$con = db_connect();
$message = isset($_GET['message']) ? htmlspecialchars($_GET['message'], ENT_QUOTES, 'UTF-8') : null;
$sql = "SELECT i.cpf, p.nomePessoa, i.salario, p.dataNasc " .
       "FROM Instrutor i " .
       "JOIN Pessoa p ON i.cpf = p.cpf " .
       "ORDER BY p.nomePessoa";
$result = mysqli_query($con, $sql);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Instrutores</title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } table { border-collapse: collapse; width: 100%; } th, td { border: 1px solid #888; padding: 8px; text-align: left; } th { background: #ddd; }</style>
</head>
<body>
    <h1>Instrutores</h1>
    <?php if ($message): ?>
        <p style="color: green;"><?php echo $message; ?></p>
    <?php endif; ?>
    <p><a href="instrutor_form.php">Cadastrar novo instrutor</a></p>
    <table>
        <tr>
            <th>Nome</th>
            <th>CPF</th>
            <th>Data Nasc.</th>
            <th>Salário</th>
            <th>Ações</th>
        </tr>
        <?php while ($row = mysqli_fetch_assoc($result)): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['nomePessoa'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['cpf'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['dataNasc'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo number_format($row['salario'], 2, ',', '.'); ?></td>
                <td>
                    <a href="instrutor_form.php?cpf=<?php echo urlencode($row['cpf']); ?>">Editar</a> |
                    <a href="instrutor_excluir.php?cpf=<?php echo urlencode($row['cpf']); ?>" onclick="return confirm('Deseja excluir este instrutor?');">Excluir</a>
                </td>
            </tr>
        <?php endwhile; ?>
    </table>
    <p><a href="index.html">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
