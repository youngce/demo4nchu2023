# Demo Codes
## Prerequisite
1. [Install Docker](https://docs.docker.com/get-docker/)
<!-- 2. [run spark on docker](https://hub.docker.com/r/apache/spark) -->

下載測試資料
```bash
cd data/
# spark's readme doc
wget https://raw.githubusercontent.com/apache/spark/master/README.md
# movielens dataset https://grouplens.org/datasets/movielens/
wget https://files.grouplens.org/datasets/movielens/ml-25m.zip && unzip ml-25m.zip

cd ..


```
## RDBMS Demo

```bash
# Setup Mysql Server
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.2
# connect to Mysql Server
docker exec -it some-mysql mysql -uroot -pmy-secret-pw
```

```sql
CREATE DATABASE library;
SHOW DATABASES;

USE library;
-- should be show empty set
SHOW TABLES;

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    publication_year INT,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- should find books and authors
SHOW TABLES;

-- Insert data into the authors table
INSERT INTO authors (author_id, first_name, last_name)
VALUES
    (1, 'J.K.', 'Rowling'),
    (2, 'George', 'Orwell'),
    (3, 'J.R.R.', 'Tolkien');

-- Insert data into the books table
INSERT INTO books (book_id, title, publication_year, author_id)
VALUES
    (1, 'Harry Potter and the Philosopher''s Stone', 1997, 1),
    (2, '1984', 1949, 2),
    (3, 'The Hobbit', 1937, 3);

```

```sql
-- 查詢目前資料庫中有的全部書籍名稱
SELECT * FROM books;
-- 將 books 中所有資料照發表年度排序 
SELECT * FROM books ORDER BY publication_year DESC;
-- 查詢1990年後發表的新書
SELECT * FROM books WHERE publication_year>1990;
-- 承上，並顯示出該書的作者名稱
SELECT * FROM books JOIN authors ON books.author_id = authors.author_id WHERE publication_year>1990;

-- 作為圖書館管理員，想對每本書增加標籤(tag) , 該如何在不影響現有資料表(books and authors)下進行修改呢？
CREATE TABLE tags (
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR(50)
);
CREATE TABLE book_tags (
    book_id INT,
    tag_id INT,
    PRIMARY KEY (book_id, tag_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);
-- Insert data into the tags table
INSERT INTO tags (tag_id, tag_name)
VALUES
    (1, 'Fiction'),
    (2, 'Science Fiction'),
    (3, 'Fantasy'),
    (4, 'Dystopian');

-- Insert data into the book_tags table to associate books with tags
INSERT INTO book_tags (book_id, tag_id)
VALUES
    (1, 1), -- Harry Potter and the Philosopher's Stone is tagged as Fiction
    (2, 1), -- 1984 is tagged as Fiction
    (3, 1), -- The Hobbit is tagged as Fiction
    (2, 2), -- 1984 is tagged as Science Fiction
    (3, 3), -- The Hobbit is tagged as Fantasy
    (2, 4); -- 1984 is tagged as Dystopian

SELECT tags.tag_name
FROM tags
JOIN book_tags ON tags.tag_id = book_tags.tag_id
WHERE book_tags.book_id = 2; -- Retrieve tags for book with book_id 2 (1984)


```

## PySpark Demo
### Launch PySpark

```bash
docker run -it --rm -v ./data:/opt/spark/work-dir apache/spark:3.5.0 /bin/bash

# check dataset
ls ml-25m
## check spark
/opt/spark/bin/pyspark --version

/opt/spark/bin/pyspark
```

### Case 0: Your First Case for Spark
```python
spark.range(1000 * 1000 * 1000).count()
```
### Case 1: Pi estimation

```python

import random
NUM_SAMPLES=100* 1000*1000
def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1

NUM_GREEN = sc.parallelize(range(0, NUM_SAMPLES)) \
             .filter(inside).count()
print("Pi is roughly %f" % (4.0 * NUM_GREEN / NUM_SAMPLES))

```


### Case 2: WorkCount

```python
file="README.md"
text_file = sc.textFile(file)
word_counts = text_file.flatMap(lambda line: line.split(" ")) \
             .map(lambda word: (word, 1)) \
             .reduceByKey(lambda a, b: a + b)

word_counts.collect()
```

### Case 3: Data Profiling

```python


df=spark.read.option("header","true").option("inferSchema","true").csv("ml-25m/ratings.csv")
df.show()
df.printSchema()
df.describe().show()

```

