<?php
include __DIR__ . '/db.php';
$con = db_connect();
if (!isset($_GET['cpf']) || trim($_GET['cpf']) === '') {
    redirect('alunos.php', 'CPF inválido para exclusão.');
}
$cpf = escape($con, $_GET['cpf']);
$sql = "DELETE FROM Pessoa WHERE cpf='${cpf}'";
if (!mysqli_query($con, $sql)) {
    $error = mysqli_error($con);
    mysqli_close($con);
    redirect('alunos.php', 'Erro ao excluir aluno: ' . $error);
}
mysqli_close($con);
redirect('alunos.php', 'Aluno excluído com sucesso.');
