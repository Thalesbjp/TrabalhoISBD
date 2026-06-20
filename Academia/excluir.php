<?php
include("./config.php");
$con = mysqli_connect($host, $login, $senha, $bd);
$sql = "DELETE FROM Pessoa WHERE cpf = '".$_GET['cpf']."'";
mysqli_query($con, $sql);
mysqli_close($con);
header("location: ./index.php");
?>