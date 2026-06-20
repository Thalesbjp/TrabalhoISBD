<?php
include __DIR__ . '/db.php';
$con = db_connect();
$cpf = '';
$nome = '';
$dataNasc = '';
$salario = '';
$editing = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $cpf = escape($con, $_POST['cpf']);
    $nome = escape($con, $_POST['nome']);
    $dataNasc = escape($con, $_POST['dataNasc']);
    $salario = str_replace(',', '.', $_POST['salario']);
    $cpfOld = isset($_POST['cpf_old']) ? escape($con, $_POST['cpf_old']) : null;

    if ($cpfOld) {
        $sqlPessoa = "UPDATE Pessoa SET nomePessoa='${nome}', dataNasc='${dataNasc}' WHERE cpf='${cpfOld}'";
        if (!mysqli_query($con, $sqlPessoa)) {
            $message = 'Erro ao atualizar pessoa: ' . mysqli_error($con);
        } else {
            $sqlInstrutor = "UPDATE Instrutor SET salario=${salario} WHERE cpf='${cpfOld}'";
            if (!mysqli_query($con, $sqlInstrutor)) {
                $message = 'Erro ao atualizar instrutor: ' . mysqli_error($con);
            } else {
                redirect('instrutores.php', 'Instrutor atualizado com sucesso.');
            }
        }
    } else {
        $sqlPessoa = "INSERT INTO Pessoa (cpf, nomePessoa, dataNasc) VALUES ('${cpf}', '${nome}', '${dataNasc}')";
        if (!mysqli_query($con, $sqlPessoa)) {
            $message = 'Erro ao cadastrar pessoa: ' . mysqli_error($con);
        } else {
            $sqlInstrutor = "INSERT INTO Instrutor (cpf, salario) VALUES ('${cpf}', ${salario})";
            if (!mysqli_query($con, $sqlInstrutor)) {
                $message = 'Erro ao cadastrar instrutor: ' . mysqli_error($con);
                mysqli_query($con, "DELETE FROM Pessoa WHERE cpf='${cpf}'");
            } else {
                redirect('instrutores.php', 'Instrutor cadastrado com sucesso.');
            }
        }
    }
}

if (isset($_GET['cpf'])) {
    $cpf = escape($con, $_GET['cpf']);
    $editing = true;
    $sql = "SELECT p.nomePessoa, p.dataNasc, i.salario FROM Instrutor i JOIN Pessoa p ON i.cpf = p.cpf WHERE i.cpf='${cpf}'";
    $res = mysqli_query($con, $sql);
    if ($row = mysqli_fetch_assoc($res)) {
        $nome = $row['nomePessoa'];
        $dataNasc = $row['dataNasc'];
        $salario = $row['salario'];
    } else {
        redirect('instrutores.php', 'Instrutor não encontrado.');
    }
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title><?php echo $editing ? 'Editar Instrutor' : 'Cadastrar Instrutor'; ?></title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } label { display: block; margin-top: 12px; } input { width: 300px; padding: 6px; }</style>
</head>
<body>
    <h1><?php echo $editing ? 'Editar Instrutor' : 'Cadastrar Instrutor'; ?></h1>
    <?php if (!empty($message)): ?>
        <p style="color: red;"><?php echo htmlspecialchars($message, ENT_QUOTES, 'UTF-8'); ?></p>
    <?php endif; ?>
    <form method="post" action="instrutor_form.php">
        <?php if ($editing): ?>
            <input type="hidden" name="cpf_old" value="<?php echo htmlspecialchars($cpf, ENT_QUOTES, 'UTF-8'); ?>">
        <?php endif; ?>
        <label>CPF:<br>
            <input type="text" name="cpf" value="<?php echo htmlspecialchars($cpf, ENT_QUOTES, 'UTF-8'); ?>" <?php echo $editing ? 'readonly' : 'required'; ?> maxlength="11">
        </label>
        <label>Nome:<br>
            <input type="text" name="nome" value="<?php echo htmlspecialchars($nome, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="80">
        </label>
        <label>Data de Nascimento:<br>
            <input type="date" name="dataNasc" value="<?php echo htmlspecialchars($dataNasc, ENT_QUOTES, 'UTF-8'); ?>" required>
        </label>
        <label>Salário:<br>
            <input type="text" name="salario" value="<?php echo htmlspecialchars($salario, ENT_QUOTES, 'UTF-8'); ?>" required>
        </label>
        <p><button type="submit">Salvar</button></p>
    </form>
    <p><a href="instrutores.php">Voltar à lista de instrutores</a> | <a href="index.php">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
