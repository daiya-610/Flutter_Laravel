## MySQL

### 1.コマンド - MySQL ver.8以降

1-1.MySQLの状態確認
```
service mysql status
```
または
```
/etc/init.d/mysqld status
```

1-2.MySQLの起動
```
mysql.server start
```
または
```
/etc/init.d/mysqld start
```

1-3.MySQLの停止
```
mysql.server stop
```
または
```
/etc/init.d/mysqld stop
```

1-4.MySQLの再起動
```
mysql.server restart
```
または
```
/etc/init.d/mysqld restart
```

1-5.MySQLログイン
```
mysql -u root -p

```
1-6. ユーザー作成
```
mysql> create user `testuser`@`localhost` IDENTIFIED BY 'password';
```

1-7. 権限付与
```
mysql> grant all privileges on DB名.* to 'user'@'localhost';
```

1-8. ユーザー一覧表示
```
select Host,User,authentication_string from mysql.user;
```
