from pyspark.sql import SparkSession
import argparse
import os
from pyspark.sql.functions import col, to_timestamp, lit  # Добавить импорт функции lit

def get_mysql_column_definition(df_schema):
    """Конвертирует схему Spark DataFrame в строку определений столбцов для MySQL"""
    type_mapping = {
        "integer": "INT",
        "string": "VARCHAR(255)",
        "long": "BIGINT",
        "double": "DOUBLE",
        "date": "DATE",
        "int": "INT",
        "bigint": "BIGINT",
        "timestamp": "TIMESTAMP",
    }

    def get_mysql_type(field_type):
        simple_type = field_type.simpleString()
        if simple_type.startswith("decimal"):
            return "DECIMAL" 
        return type_mapping.get(simple_type, "TEXT")

    return ", ".join([f"`{field.name}` {get_mysql_type(field.dataType)}" for field in df_schema.fields])

# Создание парсера аргументов
parser = argparse.ArgumentParser(description='Import data from S3 to MySQL for a specific table')
parser.add_argument('--S3_INPUT_PATH', required=True)
parser.add_argument('--TABLE_NAME', required=True)
parser.add_argument('--COLUMNS', nargs='+', required=True)
parser.add_argument('--start_date', default=None)  # optional
parser.add_argument('--end_date', default=None)  # optional
args = parser.parse_args()

# Инициализация Spark Session
spark = SparkSession.builder \
    .appName("Data Importer") \
    .config("spark.jars", "/usr/local/lib/glue_jars/mysql-connector-java-8.0.26.jar") \
    .config("spark.hadoop.fs.s3a.access.key", os.getenv('MY_AWS_ACCESS_KEY_ID')) \
    .config("spark.hadoop.fs.s3a.secret.key", os.getenv('MY_AWS_SECRET_ACCESS_KEY')) \
    .config("spark.hadoop.fs.s3a.endpoint", "s3.amazonaws.com") \
    .config("spark.sql.legacy.timeParserPolicy", "LEGACY") \
    .getOrCreate()

# Получение аргументов
s3_input_path = args.S3_INPUT_PATH
table_name = args.TABLE_NAME.replace('.', '_').replace('-', '_')
columns = args.COLUMNS
start_date = args.start_date
end_date = args.end_date

# Подключение к MySQL
mysql_host = "172.24.0.2"
mysql_db = os.getenv('MYSQL_DATABASE')
mysql_user = 'root'
mysql_password = 'rootpassword'
mysql_url = f"jdbc:mysql://{mysql_host}:3306/{mysql_db}?rewriteBatchedStatements=true"

# Чтение данных из S3
df = spark.read.parquet(f"{s3_input_path}/{args.TABLE_NAME}/")

# Преобразование строк с датами в timestamp, если они предоставлены
if start_date:
    df = df.filter(to_timestamp(col("lastupdatedtime"), 'yyyy-MM-dd HH:mm:ss') >= to_timestamp(lit(start_date), 'yyyy-MM-dd HH:mm:ss'))
if end_date:
    df = df.filter(to_timestamp(col("lastupdatedtime"), 'yyyy-MM-dd HH:mm:ss') <= to_timestamp(lit(end_date), 'yyyy-MM-dd HH:mm:ss'))

# Выбор только необходимых столбцов
df = df.select(*columns)

# Получение определений столбцов для MySQL
mysql_column_definition = get_mysql_column_definition(df.schema)

# Запись в MySQL
df.write \
    .format("jdbc") \
    .option("url", mysql_url) \
    .option("driver", "com.mysql.cj.jdbc.Driver") \
    .option("dbtable", f"`{table_name}`") \
    .option("user", mysql_user) \
    .option("password", mysql_password) \
    .option("createTableColumnTypes", mysql_column_definition) \
    .mode("append") \
    .save()

# Остановка Spark Session
spark.stop()
