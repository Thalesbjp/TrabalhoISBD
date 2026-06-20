<?php
header("Content-Type: text/html; charset=iso-8859-1", true);
include("./config.php");
$con = mysqli_connect($host, $login, $senha, $bd);
?>
<html>
<head><title>Gestão Acadêmica</title></head>
<body>
<center><h3>Alunos Matriculados</h3></center>
<table border="1" align="center" width="80%">
    <tr bgcolor="grey">
        <th>Nome</th><th>CEP</th><th>Plano</th><th>Ações</th>
    </tr>
    <?php
    $sql = "SELECT p.nomePessoa, a.cep, pl.nomePlano, a.cpf 
            FROM Aluno a 
            JOIN Pessoa p ON a.cpf = p.cpf 
            JOIN Plano pl ON a.idPlano = pl.idPlano";
    $tabela = mysqli_query($con, $sql);
    while($d = mysqli_fetch_array($tabela)){
        echo "<tr><td>{$d['nomePessoa']}</td><td>{$d['cep']}</td><td>{$d['nomePlano']}</td>
              <td align='center'>
                <a href='excluir.php?cpf={$d['cpf']}'>Excluir</a> | 
                <a href='form_incluir.php?cpf={$d['cpf']}'>Editar</a>
              </td></tr>";
    }
    mysqli_close($con);
    ?>
</table>
<center><br><a href='form_incluir.php'>Cadastrar Novo Aluno</a></center>
</body>
</html>