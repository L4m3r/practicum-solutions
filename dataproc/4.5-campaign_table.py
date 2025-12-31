from pyspark.sql import SparkSession


def main():
    spark = (
        SparkSession.builder.master("yarn").appName("4.5 Spark Upload").getOrCreate()
    )
    df = (
        spark.read.option("header", True)
        .option("inferSchema", True)
        .csv("s3a://l4m3r-dataproc-tasks/data/campaign_table.csv")
    )
    df.write.mode("overwrite").format("delta").saveAsTable("module_4.campaign_table")


if __name__ == "__main__":
    main()
