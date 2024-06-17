# MySQL コマンド

## 1.起動
1-1. MySQLの起動
```
mysql -u root -p password;
```

## 2.データベース
2-1. データベースを作成
```
CREATE DATABASE データベース名;
```

2-2. 使うデータベースを切り替える
```
USE データベース名;
```

2-3. 現在のデータベースを確認
```
SELECT DATABASE();
```

2-4. データベースの中身（一覧）を確認
```
SHOW DATABASES;
```

2-5. データベースを削除
```
DROP DATABSE データベース名;
```

## 3.テーブル
3-1. テーブルを作成
```
CREATE TABLE テーブル名(
カラム名 型 その他,
カラム名 型 その他
);
```

- 例：
```
create table item_category (
category_id int auto_increment not null primary key,
category_name varchar(256) not null 
);
```

3-2. テーブルを削除
```
DROP TABLE テーブル名;
```

3-3. テーブルの定義を確認
```
DESC テーブル名;
```

3-4. テーブルに値（データ）を挿入
```
INSERT INTO テーブル名（カラム名,カラム名,...）VALUES(データ, データ),(データ,'データ');
```

- 例：
```
insert into item_category(category_id, category_name) values (1,”家具”), (2,”飲料”), (3,”食品”);
```

3-5. 作ったテーブルを見る
```
show tables;　（全てのテーブル
```

3-6. テーブルの構造を見る
```
DESC テーブル名;
show columns from テーブル名;
```

## 4.データ
4-1. 値（データ）を更新
```
UPDATE [テーブル名] SET [COLUMN名] = '新しい値';
UPDATE user SET name = '新しい名前';
```

4-2. 値（データ）を削除
```
DELETE FROM [テーブル名] WHERE カラム名 = 値;
```

- 例：
```
DELETE FROM user WHERE id = 10;
```


## 5.外部キー
5-1. 外部キー制約の確認
```
SHOW CREATE TABLE テーブル名;
```

5-2. 外部キー制約の追加
```
alter table テーブル名 add foreign key (カラム名) references 外部キーを付与したいテーブル名(カラム名);
```

- 例：
```
alter table item_list add foreign key (category_id) references item_category(category_id);
```

5-3. テーブル作成と同時に主キー、外部キー制約を追加
```
CREATE TABLE テーブル名(
test_no INT NOT NULL,
minitest VARCHAR(20),
time INT,
classroom_id VARCHAR(10),
PRIMARY KEY(test_no),
FOREIGN KEY(classroom_id) REFERENCES classrooms(classroom_id)
);
```

## 6. 結合

6-1. テーブル結合（内部結合）
```
SELECT
    テーブル名.カラム名,（続く）
FROM
    テーブル名 INNER JOIN 結合したいテーブル名
    ON テーブル名.列名 = テーブル名.列名;
```

- 例：shopテーブルとitemテーブル、item_idが主キーと外部キーの場合

```
SELECT
  shop.shop_name,
  shop.item_id, 
  item.item_name, 
  item.price, 
  shop.quantity 
FROM
  shop INNER JOIN item 
ON
  shop.item_id = item.item_id;
```

6-2. テーブル結合（外部結合）
```
$ SELECT
    テーブル名.カラム名,（続く）
FROM
    テーブル名 LEFT (OUTER) JOIN 結合したいテーブル名
    ON テーブル名.列名 = テーブル名.列名;
```
- OUTERはつけても、つけなくてもOK。

## 7.サブクエリ
7-1. SELECT文の中にSELECT文を使う検索
```
SELECT
    テーブル名1.カラム名,
    テーブル名1.カラム名,
    テーブル名2.カラム名,
    テーブル名3.カラム名,
    テーブル名3.カラム名
  FROM
  　テーブル名2 INNER JOIN テーブル名3
  　ON テーブル名1.カラム名 = テーブル名2.カラム名
  WHERE
  　テーブル名3.カラム名 IN (
  　   SELECT カラム名
  　   FROM カラム名
  　   WHERE 検索したいカラム名 = 値
  );
```

- 例：
```
SELECT
 students.student_name,
 students.company_name,
 tests.minitest,
 testData.times,
 testData.test_date,
 testData.score
FROM tests
INNER JOIN testData
 ON tests.test_no = testData.test_no
INNER JOIN students
 ON testData.student_no = students.student_no
WHERE
    testData.student_no IN (
    SELECT student_no
    FROM students
    WHERE student_name = '鈴木一郎'
);
```

## 8.エイリアス
8-1. テーブルにSQL内でのみ扱える別名をつける

```
SELECT
    A.カラム名,
    B.カラム名,
    C.カラム名
  FROM
    Aをつけたいテーブル名 A INNER JOIN Bをつけたいテーブル名 B
        ON A.カラム名 = B.karamumei
    INNER JOIN Cをつけたいテーブル名   C
        ON B.カラム名 = C.カラム名;
```

- 例：
```
select
 s.student_name,
 s.company_name,
 t.minitest,
 td.times,
 td.test_date,
 td.score
from tests as t inner join testData as td
 on t.test_no = td.test_no
inner join (
 select student_no, student_name, company_name
 from students
 where student_name = '鈴木一郎'
) s
on td.student_no = s.student_no;
```

## 9.ソート（並び替え）
9-1. ソート（昇順）
```
SELECT * FROM テーブル名 ORDER BY カラム名 ASC;
```

9-2. ソート（降順）
```
SELECT * FROM テーブル名 ORDER BY カラム名 DESC;
```

## 10.グルーピング（指定したカラムでまとめる）
10-1. グルーピング
```
SELECT カラム名 FROM テーブル名 GROUP BY カラム名;
```

## 11.集約関数（計算した結果を表示、合計や平均、最大値など）
11-1. 集約関数
```
SELECT MAX（カラム名） FROM テーブル名;
```


## 12.検索
12-1. あいまいな検索（ワイルドカード）
```
SELECT * FROM テーブル名 WHERE カラム名 LIKE '%テスト%';
```

- カラムからテストとつくデータを抽出
%と_が使える
1. 部分一致
2. 前方一致
3. 後方一致

