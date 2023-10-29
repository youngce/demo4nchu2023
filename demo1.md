# Demo 1: Calculate Workcount by Spark

## Prerequisite

1. [Install Docker](https://docs.docker.com/get-docker/)
2. [prun spark on docker](https://hub.docker.com/r/apache/spark)


```bash

docker run -it --rm -v ./data:/opt/spark/work-dir\ apache/spark:3.5.0 /bin/bash
# /opt/spark/bin/pyspark
```

下載資料
```bash
# spark's readme doc
wget https://raw.githubusercontent.com/apache/spark/master/README.md
# movielens dataset https://grouplens.org/datasets/movielens/
wget https://files.grouplens.org/datasets/movielens/ml-25m.zip


```
First Case for Spark
```python
spark.range(1000 * 1000 * 1000).count()
```

### Case 1: WorkCount

```python
import urllib.request
def display_top_n_lines(file_path, n):
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            for i, line in enumerate(file):
                if i < n:
                    print(line, end="")
                else:
                    break
    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

def download_file(url, dest):
    local_file_path = dest
    # Use urllib to fetch the content from the URL
    with urllib.request.urlopen(url) as response:
        # Read the content from the response
        content = response.read().decode('utf-8')
        # Write the content to a local file
        with open(local_file_path, "w", encoding="utf-8") as file:
            file.write(content)
    print(f"File saved to {local_file_path}")



url= "https://raw.githubusercontent.com/apache/spark/master/README.md"
dest="README.md"
download_file(url,"README.md")
top_n=20
display_top_n_lines(dest,top_n )


text_file = sc.textFile(dest)
word_counts = text_file.flatMap(lambda line: line.split(" ")) \
             .map(lambda word: (word, 1)) \
             .reduceByKey(lambda a, b: a + b)

word_counts.collect()

```

### Case 2: Pi estimation

```python

import random
NUM_SAMPLES=1000*1000
def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1

count = sc.parallelize(range(0, NUM_SAMPLES)) \
             .filter(inside).count()
print("Pi is roughly %f" % (4.0 * count / NUM_SAMPLES))

```