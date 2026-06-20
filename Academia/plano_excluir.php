<?php
include __DIR__ . '/db.php';
$con = db_connect();
if (!isset($_GET['idPlano']) || trim($_GET['idPlano']) === '') {
    redirect('planos.php', 'ID do plano inválido para exclusão.');
}
$idPlano = (int) $_GET['idPlano'];
$sql = "DELETE FROM Plano WHERE idPlano=${idPlano}";
if (!mysqli_query($con, $sql)) {
    $error = mysqli_error($con);
    mysqli_close($con);
    redirect('planos.php', 'Erro ao excluir plano: ' . $error);
}
mysqli_close($con);
redirect('planos.php', 'Plano excluído com sucesso.');
