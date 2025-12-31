import importlib
import site
import subprocess
import sys
import time

from pyspark.sql import SparkSession


def install_plugin(plugin_name):
    subprocess.check_call([sys.executable, "-m", "pip", "install", plugin_name])


def truncate_clickhouse_table(host, username, password, port=8123):
    # Проверка наличия пакета
    subprocess.check_call([sys.executable, "-m", "pip", "show", "clickhouse-connect"])

    # Обновление пути sys.path после добавления библиотеки
    importlib.reload(site)
    import clickhouse_connect

    client = clickhouse_connect.get_client(
        host=host, port=port, username=username, password=password
    )

    # Пример команды
    client.command("TRUNCATE TABLE `dataproc-db`.demographic_datamart")
    client.close()


def main():
    # Установка пакета clickhouse-connect
    install_plugin("clickhouse-connect==0.8.18")

    # Инициализация Spark-сессии
    spark = (
        SparkSession.builder.master("yarn")
        .appName("7.4 Datamart to Clickhouse")
        .getOrCreate()
    )

    # Инициализация параметров подключения к ClickHouse
    jdbc_port = 8443
    # Не забудьте заменить значение переменной
    jdbc_hostname = "c-c9qp36qmc12li0r57fc8.rw.mdb.yandexcloud.net"
    jdbc_database = "dataproc-db"
    jdbc_username = "dataproc-user"
    # Не забудьте заменить значение переменной
    jdbc_password = "FaiPhoChoh3eihu5"
    jdbc_url = f"jdbc:clickhouse://{jdbc_hostname}:{jdbc_port}/{jdbc_database}?ssl=true"

    # Считывание подготовленной витрины
    demographic_datamart = spark.table("module_7.demographic_datamart")

    # Очистка таблицы в ClickHouse
    truncate_clickhouse_table(
        host=jdbc_hostname, username=jdbc_username, password=jdbc_password
    )

    # Запись данных в ClickHouse
    demographic_datamart.write.format("jdbc").mode("append").option(
        "driver", "com.clickhouse.jdbc.ClickHouseDriver"
    ).option("url", jdbc_url).option("dbtable", "demographic_datamart").option(
        "user", jdbc_username
    ).option("password", jdbc_password).save()


if __name__ == "__main__":
    main()
