// get occurrence counts for 2021 - 2022
 
val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext.implicits._

val nodes = spark.read.
option("sep", "\t").
option("header", "true").
option("inferSchema", "true").
csv("nodes.tsv")

val df_old = sqlContext.sql("SELECT * FROM snapshot.occurrence_20210101").
groupBy("dataset_id").
count().
withColumnRenamed("count","old_count").
withColumnRenamed("dataset_id","dataset_id_old")

val df_cur = sqlContext.sql("SELECT * FROM snapshot.occurrence_20220101").
groupBy("dataset_id").
count().
withColumnRenamed("count","cur_count").
withColumnRenamed("dataset_id","dataset_id_cur")

val df_join = df_cur.join(df_old,
df_old("dataset_id_old") === df_cur("dataset_id_cur"),"full").
withColumn("old_count", when($"old_count".isNull, 0).otherwise($"old_count")).
withColumnRenamed("dataset_id_cur","dataset_id").
select("dataset_id","old_count","cur_count").
withColumn("occ_diff",$"cur_count" - $"old_count")

val df_export = df_join.join(nodes,df_join("dataset_id") === nodes("datasetkey")).drop("dataset_id")

import sys.process._
import org.apache.spark.sql.SaveMode

val save_table_name = "performance_indicators_nodes"

df_export.
write.format("csv").
option("sep", "\t").
option("header", "false"). // add header later
mode(SaveMode.Overwrite).
save(save_table_name)

// custom downloads dir 
val export_dir = "/mnt/auto/misc/download.gbif.org/custom_download/jwaller/"

// export tsv file from scala to custom downloads 
(s"hdfs dfs -ls")!
(s"rm " + export_dir + save_table_name)!
(s"hdfs dfs -getmerge /user/jwaller/"+ save_table_name + " " + export_dir + save_table_name+ ".tsv")!
(s"head " + export_dir + save_table_name + ".tsv")!
val header = "1i " + df_export.columns.toSeq.mkString("""\t""")
Seq("sed","-i",header,export_dir+save_table_name+".tsv").!
(s"ls -lh " + export_dir)!

System.exit(0)

