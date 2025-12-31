from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    coalesce,
    col,
    count,
    countDistinct,
    lit,
    max,
    min,
    round,
    sum,
    when,
)


def main():
    # Инициализация Spark-сессии
    spark = (
        SparkSession.builder.master("yarn").appName("7.4 Datamart Init").getOrCreate()
    )

    # Инициализация переменных с нужными объектами
    transactional_data = spark.table(f"module_4.transactional_data_1")
    hh_demographic = spark.table("module_4.hh_demographic")

    # Создание схемы module_7
    spark.sql("create schema if not exists module_7")

    # Определение первого подзапроса
    transactional_data_hh = transactional_data.groupBy("household_key").agg(
        countDistinct("DAY").alias("DAY_nb"),
        round((max("DAY") - min("DAY")) / countDistinct("DAY"), 1).alias("frequency"),
        round(sum("SALES_VALUE") / countDistinct("DAY"), 2).alias("SALES_VALUE_day"),
        round(sum("RETAIL_DISC") / countDistinct("DAY"), 2).alias("RETAIL_DISC_day"),
        round(sum("COUPON_DISC") / countDistinct("DAY"), 2).alias("COUPON_DISC_day"),
        when(sum("COUPON_DISC") != 0, True).otherwise(False).alias("Use_coupon"),
    )

    # Определение второго подзапроса
    coupon_hh = (
        transactional_data.filter(col("COUPON_DISC") != 0)
        .groupBy("household_key")
        .agg(count("household_key").alias("nb_coupon"))
    )

    # Объединение данных по заданным условиям
    result_df = (
        transactional_data_hh.join(coupon_hh, on="household_key", how="left")
        .join(hh_demographic, on="household_key", how="left")
        .select(
            "household_key",
            "hh_demographic.AGE_DESC",
            "hh_demographic.MARITAL_STATUS_CODE",
            "hh_demographic.INCOME_DESC",
            "hh_demographic.HOMEOWNER_DESC",
            "hh_demographic.HH_COMP_DESC",
            "hh_demographic.HOUSEHOLD_SIZE_DESC",
            "hh_demographic.KID_CATEGORY_DESC",
            "DAY_nb",
            "frequency",
            "SALES_VALUE_day",
            "RETAIL_DISC_day",
            coalesce("nb_coupon", lit(0)).alias("nb_coupon"),
            "COUPON_DISC_day",
            "Use_coupon",
        )
        .filter(col("AGE_DESC").isNotNull())
        .orderBy("household_key")
    )

    result_df.write.mode("overwrite").format("delta").saveAsTable(
        "module_7.demographic_datamart"
    )


if __name__ == "__main__":
    main()
