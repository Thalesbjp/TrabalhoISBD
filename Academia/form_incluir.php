<?php include("./config.php"); $con = mysqli_connect($host, $login, $senha, $bd); ?>
<form method="POST" action="incluir.php">
    <h3>Dados do Aluno</h3>
    CPF: <input type="text" name="cpf" <?php if(isset($_GET['cpf'])) echo "readonly value='".$_GET['cpf']."'"; ?>><br>
    Nome: <input type="text" name="nome"><br>
    Data Nasc: <input type="date" name="dataNasc"><br>
    CEP: <input type="text" name="cep"><br>
    Plano (ID): <input type="number" name="idPlano"><br>
    <input type="submit" value="Gravar">
</form>