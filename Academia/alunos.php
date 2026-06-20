<?php
include __DIR__ . '/db.php';
$con = db_connect();
$message = isset($_GET['message']) ? htmlspecialchars($_GET['message'], ENT_QUOTES, 'UTF-8') : null;
$sql = "SELECT a.cpf, p.nomePessoa, a.cep, pl.nomePlano, a.cidade, a.estado, a.dataAdesao, a.dataTermino " .
       "FROM Aluno a " .
       "JOIN Pessoa p ON a.cpf = p.cpf " .
       "JOIN Plano pl ON a.idPlano = pl.idPlano " .
       "ORDER BY p.nomePessoa";
$result = mysqli_query($con, $sql);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Alunos</title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } table { border-collapse: collapse; width: 100%; } th, td { border: 1px solid #888; padding: 8px; text-align: left; } th { background: #ddd; }</style>
</head>
<body>
    <h1>Alunos</h1>
    <?php if ($message): ?>
        <p style="color: green;"><?php echo $message; ?></p>
    <?php endif; ?>
    <p><a href="aluno_form.php">Cadastrar novo aluno</a></p>
    <table>
        <tr>
            <th>Nome</th>
            <th>CPF</th>
            <th>CEP</th>
            <th>Plano</th>
            <th>Cidade</th>
            <th>Estado</th>
            <th>Adesão</th>
            <th>Término</th>
            <th>Ações</th>
        </tr>
        <?php while ($row = mysqli_fetch_assoc($result)): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['nomePessoa'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['cpf'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['cep'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['nomePlano'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['cidade'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['estado'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['dataAdesao'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td><?php echo htmlspecialchars($row['dataTermino'], ENT_QUOTES, 'UTF-8'); ?></td>
                <td>
                    <a href="aluno_form.php?cpf=<?php echo urlencode($row['cpf']); ?>">Editar</a> |
                    <a href="aluno_excluir.php?cpf=<?php echo urlencode($row['cpf']); ?>" onclick="return confirm('Deseja excluir este aluno?');">Excluir</a>
                </td>
            </tr>
        <?php endwhile; ?>
    </table>
    <p><a href="index.php">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
