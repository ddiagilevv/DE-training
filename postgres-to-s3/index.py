from pyspark.sql import SparkSession
from pyspark.sql.functions import date_format, from_utc_timestamp, current_timestamp
import argparse
import os
import sys

# Парсинг аргументов командной строки
parser = argparse.ArgumentParser(description='Export data from PostgreSQL to S3')
parser.add_argument('--DATABASE_URL', required=True)
parser.add_argument('--S3_OUTPUT_PATH', required=True)
parser.add_argument('--TABLE_NAME', required=True)
parser.add_argument('--COLUMNS', nargs='+', required=True)
parser.add_argument('--start_date', help='Start date for filtering records')
parser.add_argument('--end_date', help='End date for filtering records')
args = parser.parse_args()

spark = SparkSession.builder \
    .appName("ExportToS3") \
    .config("spark.hadoop.fs.s3a.access.key", os.getenv('MY_AWS_ACCESS_KEY_ID')) \
    .config("spark.hadoop.fs.s3a.secret.key", os.getenv('MY_AWS_SECRET_ACCESS_KEY')) \
    .config("spark.hadoop.fs.s3a.endpoint", "s3.amazonaws.com") \
    .config("spark.sql.session.timeZone", "UTC") \
    .getOrCreate()

jdbc_url = args.DATABASE_URL
postgres_user = os.getenv('POSTGRES_USER')
postgres_password = os.getenv('POSTGRES_PASSWORD')

table_name = args.TABLE_NAME

# Получаем список столбцов из аргументов напрямую
columns = args.COLUMNS

# Создаем SQL-запрос с учетом аргументов даты
sql_query = f"SELECT {', '.join(columns)} FROM {table_name}"

if args.start_date and args.end_date:
    sql_query += f" WHERE lastupdatedtime BETWEEN '{args.start_date}' AND '{args.end_date}'"

# Чтение и экспорт таблицы
df = spark.read \
    .format("jdbc") \
    .option("url", jdbc_url) \
    .option("dbtable", f"({sql_query}) AS tmp") \
    .option("driver", "org.postgresql.Driver") \
    .option("user", postgres_user) \
    .option("password", postgres_password) \
    .load()

# Путь к S3
s3_output_path = args.S3_OUTPUT_PATH
if s3_output_path.endswith("/"):
    s3_output_path -= "/"

print(df)


current_timestamp_utc = spark.sql("SELECT date_format(from_utc_timestamp(current_timestamp(), 'UTC'), 'yyyyMMddHHmmss')").collect()[0][0]
schema, table = table_name.split(".")

df.write.parquet(f"{s3_output_path}/{schema}-{table}-{current_timestamp_utc}/")

spark.stop()