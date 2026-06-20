<?php
function db_connect() {
    include __DIR__ . '/config.php';
    $con = mysqli_connect($host, $login, $senha, $bd);
    if (!$con) {
        die('Erro de conexão: ' . mysqli_connect_error());
    }
    mysqli_set_charset($con, 'utf8mb4');
    return $con;
}

function escape($con, $value) {
    return mysqli_real_escape_string($con, trim($value));
}

function redirect($url, $message = null) {
    if ($message !== null) {
        $url .= (strpos($url, '?') === false ? '?' : '&') . 'message=' . urlencode($message);
    }
    header('Location: ' . $url);
    exit;
}
