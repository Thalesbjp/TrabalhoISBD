<?php
include __DIR__ . '/db.php';
$con = db_connect();
$idPlano = '';
$nomePlano = '';
$valor = '';
$editing = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idPlano = (int) $_POST['idPlano'];
    $nomePlano = escape($con, $_POST['nomePlano']);
    $valor = str_replace(',', '.', $_POST['valor']);
    $idOld = isset($_POST['idPlano_old']) ? (int) $_POST['idPlano_old'] : null;

    if ($idOld) {
        $sql = "UPDATE Plano SET nomePlano='${nomePlano}', valor=${valor} WHERE idPlano=${idOld}";
        if (!mysqli_query($con, $sql)) {
            $message = 'Erro ao atualizar plano: ' . mysqli_error($con);
        } else {
            redirect('planos.php', 'Plano atualizado com sucesso.');
        }
    } else {
        $sql = "INSERT INTO Plano (idPlano, nomePlano, valor) VALUES (${idPlano}, '${nomePlano}', ${valor})";
        if (!mysqli_query($con, $sql)) {
            $message = 'Erro ao cadastrar plano: ' . mysqli_error($con);
        } else {
            redirect('planos.php', 'Plano cadastrado com sucesso.');
        }
    }
}

if (isset($_GET['idPlano'])) {
    $idPlano = (int) $_GET['idPlano'];
    $editing = true;
    $sql = "SELECT nomePlano, valor FROM Plano WHERE idPlano=${idPlano}";
    $res = mysqli_query($con, $sql);
    if ($row = mysqli_fetch_assoc($res)) {
        $nomePlano = $row['nomePlano'];
        $valor = $row['valor'];
    } else {
        redirect('planos.php', 'Plano não encontrado.');
    }
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title><?php echo $editing ? 'Editar Plano' : 'Cadastrar Plano'; ?></title>
    <style>body { font-family: Arial, sans-serif; margin: 30px; } label { display: block; margin-top: 12px; } input { width: 300px; padding: 6px; }</style>
</head>
<body>
    <h1><?php echo $editing ? 'Editar Plano' : 'Cadastrar Plano'; ?></h1>
    <?php if (!empty($message)): ?>
        <p style="color: red;"><?php echo htmlspecialchars($message, ENT_QUOTES, 'UTF-8'); ?></p>
    <?php endif; ?>
    <form method="post" action="plano_form.php">
        <?php if ($editing): ?>
            <input type="hidden" name="idPlano_old" value="<?php echo htmlspecialchars($idPlano, ENT_QUOTES, 'UTF-8'); ?>">
        <?php endif; ?>
        <label>ID do Plano:<br>
            <input type="number" name="idPlano" value="<?php echo htmlspecialchars($idPlano, ENT_QUOTES, 'UTF-8'); ?>" <?php echo $editing ? 'readonly' : 'required'; ?> min="1">
        </label>
        <label>Nome do Plano:<br>
            <input type="text" name="nomePlano" value="<?php echo htmlspecialchars($nomePlano, ENT_QUOTES, 'UTF-8'); ?>" required maxlength="30">
        </label>
        <label>Valor:<br>
            <input type="text" name="valor" value="<?php echo htmlspecialchars($valor, ENT_QUOTES, 'UTF-8'); ?>" required>
        </label>
        <p><button type="submit">Salvar</button></p>
    </form>
    <p><a href="planos.php">Voltar à lista de planos</a> | <a href="index.php">Voltar ao menu principal</a></p>
</body>
</html>
<?php mysqli_close($con); ?>
