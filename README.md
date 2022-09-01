# Intro
Synapse Dedicated SQL Pool Jumpstart is a guideline to optimize your solution since the very beginning.

# Solution
Azure Synapse Analytics is an analytics service that encompasses enterprise data warehousing and big data analytics. A dedicated SQL pool (formerly SQL DW) refers to the enterprise data warehouse features that are available in Azure Synapse Analytics.

I share 7 points, with very useful reference links to take into account in the initial activations of SQL Pool.

# Guidelines

1. Rename Admin User: For security reasons, in productive environments, it is suggested to rename the admin user when creating the workspace.

2. Table type mapping: By default SQL Pool stores tables as Round Robin, which is good for loads (staging/bronze layers) but for consumption (Silver and Gold layers), the idea is to use Hash on the Facts and Replicated in the Dimensional tables.
Links: 
-	https://docs.microsoft.com/en-us/learn/modules/optimize-data-warehouse-query-performance-azure-synapse-analytics/4-understand-table-distribution-design
-	https://www.youtube.com/watch?v=1VS_F37GI9U&t=917s 

3. Use of Resource Class: The administrator user created in Synapse Workspace enablement (sqladminuser) is recommended to be used only for administrative tasks. For other activities such as loading and processing, it is recommended to create users in a resource class that allows you to take advantage of the capacity (DWU - memory) of the SQL Pool.
Links: 
-	https://docs.microsoft.com/en-us/learn/modules/use-data-loading-best-practices-azure-synapse-analytics/6-set-up-dedicated-accounts
-	https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/resource-classes-for-workload-management
- Script:
  Source Folder

4. Optimize indexes: After the data load is finished, it is suggested to rebuild the indexes so that the reading of the tables is optimized.
Link: 
-	https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index 
Script:
-	`ALTER INDEX ALL ON [schema].[table] REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON);`

5. Execution of statistics: It is important once the load is finished, to create the statistics of the columns that are used for the queries.
Script: 
`CREATE STATISTICS [statistics_name] ON [schema_name].[table_name]([column_name]);`

6. Cache activation: very useful when clients perform repetitive queries; with resultsetching, SQL Pool automatically caches the result.
Link: 
-	https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching 

7. Queued Queries: Keep in mind that according to the DWUs we will have a number of slots available, which limits the number of queries that can be executed concurrently. If the number of concurrent queries is exceeded, the following queries that enter will be queued, giving the impression that they are taking a long time but it is because there are other queries in execution.
Link: 
-	https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits 
