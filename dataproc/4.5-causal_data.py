from pyspark.sql import SparkSession
from pyspark.sql.functions import col


def main():
    spark = (
        SparkSession.builder.master("yarn").appName("4.5 Spark Upload").getOrCreate()
    )
    df = (
        spark.read.option("header", True)
        .option("inferSchema", True)
        .csv("s3a://l4m3r-dataproc-tasks/data/causal_data.csv")
    )
    filtered_df = df.where((col("STORE_ID") > 200) & (col("STORE_ID") < 500))
    filtered_df.write.mode("overwrite").format("delta").saveAsTable(
        "module_4.causal_data"
    )


if __name__ == "__main__":
    main()
