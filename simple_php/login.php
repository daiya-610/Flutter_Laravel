<?php

session_start();


// ユーザー名とパスワード
$valid_username = "user1";
$valid_password = "password1";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];

    if ($username === $valid_username && $password === $valid_password) {
        $_SESSION["username"] = $username;
        echo "ログインに成功しました。";
    } else {
        echo "ユーザー名またはパスワードが正しくありません。";
    }
}

?>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ログイン</title>
</head>
<body>
    <h2>ログインフォーム</h2>
    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        <label for="username">ユーザー名：</label><br>
        <input type="text" id="username" name="username"><br>
        <label for="password">パスワード：</label><br>
        <input type="password" id="password" name="password"><br><br>
        <input type="submit" value="ログイン">
    </form>
</body>
</html>