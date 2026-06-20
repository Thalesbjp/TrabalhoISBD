<?php
include __DIR__ . '/db.php';
$con = db_connect();
$message = null;
$cpf = '';
$nome = '';
$dataNasc = '';
$logradouro = '';
$numero = '';
$bairro = '';
$cidade = 'Lavras';
$estado = 'MG';
$cep = '';
$idPlano = '';
$dataAdesao = '';
$dataTermino = '';
$editing = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $cpf = escape($con, $_POST['cpf']);
    $nome = escape($con, $_POST['nome']);
    $dataNasc = escape($con, $_POST['dataNasc']);
    $logradouro = escape($con, $_POST['logradouro']);
    $numero = (int) $_POST['numero'];
    $bairro = escape($con, $_POST['bairro']);
    $cidade = escape($con, $_POST['cidade']);
    $estado = escape($con, $_POST['estado']);
    $cep = escape($con, $_POST['cep']);
    $idPlano = (int) $_POST['idPlano'];
    $dataAdesao = escape($con, $_POST['dataAdesao']);
    $dataTermino = escape($con, $_POST['dataTermino']);
    $cpfOld = isset($_POST['cpf_old']) ? escape($con, $_POST['cpf_old']) : null;

    if ($cpfOld) {
        $sqlPessoa = "UPDATE Pessoa SET nomePessoa='${nome}', dataNasc='${dataNasc}' WHERE cpf='${cpfOld}'";
        if (!mysqli_query($con, $sqlPessoa)) {
            $message = 'Erro ao atualizar pessoa: ' . mysqli_error($con);
        } else {
            $sqlAluno = "UPDATE Aluno SET logradouro='${logradouro}', numero=${numero}, bairro=" . ($bairro !== '' ? "'${bairro}'" : "NULL") . ", cidade='${cidade}', estado='${estado}', cep='${cep}', idPlano=${idPlano}, dataAdesao='${dataAdesao}', dataTermino='${dataTermino}' WHERE cpf='${cpfOld}'";
            if (!mysqli_query($con, $sqlAluno)) {
                $message = 'Erro ao atualizar aluno: ' . mysqli_error($con);
            } else {
                redirect('alunos.php', 'Aluno atualizado com sucesso.');
            }
        }
    } else {
        $sqlPessoa = "INSERT INTO Pessoa (cpf, nomePessoa, dataNasc) VALUES ('${cpf}', '${nome}', '${dataNasc}')";
        if (!mysqli_query($con, $sqlPessoa)) {
            $message = 'Erro ao cadastrar pessoa: ' . mysqli_error($con);
        } else {
            $sqlAluno = "INSERT INTO Aluno (cpf, logradouro, numero, bairro, cidade, estado, cep, idPlano, dataAdesao, dataTermino) VALUES ('${cpf}', '${logradouro}', ${numero}, " . ($bairro !== '' ? "'${bairro}'" : "NULL") . ", '${cidade}', '${estado}', '${cep}', ${idPlano}, '${dataAdesao}', '${dataTermino}')";
            if (!mysqli_query($con, $sqlAluno)) {
                $message = 'Erro ao cadastrar aluno: ' . mysqli_error($con);
                mysqli_query($con, "DELETE FROM Pessoa WHERE cpf='${cpf}'");
            } else {
                redirect('alunos.php', 'Aluno cadastrado com sucesso.');
            }
        }
    }
}

if (isset($_GET['cpf'])) {
    $cpf = escape($con, $_GET['cpf']);
    $editing = true;
    $sql = "SELECT p.nomePessoa, p.dataNasc, a.logradouro, a.numero, a.bairro, a.cidade, a.estado, a.cep, a.idPlano, a.dataAdesao, a.dataTermino " .
           "FROM Aluno a JOIN Pessoa p ON a.cpf = p.cpf WHERE a.cpf='${cpf}'";
    $res = mysqli_query($con, $sql);
    if ($row = mysqli_fetch_assoc($res)) {
        $nome = $row['nomePessoa'];
        $dataNasc = $row['dataNasc'];
        $logradouro = $row['logradouro'];
        $numero = $row['numero'];
        $bairro = $row['bairro'];
        $cidade = $row['cidade'];
        $estado = $row['estado'];
        $cep = $row['cep'];
        $idPlano = $row['idPlano'];
        $dataAdesao = $row['dataAdesao'];
        $dataTermino = $row['dataTermino'];
    } else {
        redirect('alunos.php', 'Aluno não encontrado.');
    }
}

$planos = mysqli_query($con, "SELECT idPlano, nomePlano FROM Plano ORDER BY nomePlano");
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title><?php echo $editing ? 'Editar Aluno' : 'Cadastrar Aluno'; ?></title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } label { display: block; margin-top: 12px; } input, select { width: 300px; padding: 6px; }</style>
</head>
<body>
    <h1><?php echo $editing ? 'Editar Aluno' : 'Cadastrar Aluno'; ?></h1>
    <?php if (!empty($message)): ?>
        <p style="color: red;"><?php echo htmlspecialchars($message, ENT_QUOTES, 'UTF-8'); ?></p>
    <?php endif; ?>
    <form method="post" action="aluno_form.php">
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
        <label>Logradouro:<br>
            <input type="text" name="logradouro" value="<?php echo htmlspecialchars($logradouro, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="50">
        </label>
        <label>Número:<br>
            <input type="number" name="numero" value="<?php echo htmlspecialchars($numero, ENT_QUOTES, 'UTF-8'); ?>" min="1" required>
        </label>
        <label>Bairro:<br>
            <input type="text" name="bairro" value="<?php echo htmlspecialchars($bairro, ENT_QUOTES, 'UTF-8'); ?>" maxlength="30">
        </label>
        <label>Cidade:<br>
            <input type="text" name="cidade" value="<?php echo htmlspecialchars($cidade, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="30">
        </label>
        <label>Estado:<br>
            <input type="text" name="estado" value="<?php echo htmlspecialchars($estado, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="2">
        </label>
        <label>CEP:<br>
            <input type="text" name="cep" value="<?php echo htmlspecialchars($cep, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="8">
        </label>
        <label>Plano:<br>
            <select name="idPlano" required>
                <option value="">Selecione um plano</option>
                <?php while ($plano = mysqli_fetch_assoc($planos)): ?>
                    <option value="<?php echo $plano['idPlano']; ?>" <?php if ($plano['idPlano'] == $idPlano) echo 'selected'; ?>><?php echo htmlspecialchars($plano['nomePlano'], ENT_QUOTES, 'UTF-8'); ?></option>
                <?php endwhile; ?>
            </select>
        </label>
        <label>Data de Adesão:<br>
            <input type="date" name="dataAdesao" value="<?php echo htmlspecialchars($dataAdesao, ENT_QUOTES, 'UTF-8'); ?>" required>
        </label>
        <label>Data de Término:<br>
            <input type="date" name="dataTermino" value="<?php echo htmlspecialchars($dataTermino, ENT_QUOTES, 'UTF-8'); ?>" required>
        </label>
        <p><button type="submit">Salvar</button></p>
    </form>
    <p><a href="alunos.php">Voltar à lista de alunos</a> | <a href="index.html">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
