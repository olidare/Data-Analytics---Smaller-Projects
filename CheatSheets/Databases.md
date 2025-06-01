# DataBase Knowledge

---

## Relational vs. Non-Relational Databases

Understanding the differences and knowing when to use each is fundamental.

### Relational Databases (SQL Databases)

**How they work:**

* Data is organized into tables (relations), which consist of rows and columns.
* Each table has a predefined schema (structure with column names, data types, constraints).
* Relationships between tables are defined using primary keys and foreign keys.
* They enforce ACID properties (Atomicity, Consistency, Isolation, Durability) to ensure data integrity and reliability, especially for transactional workloads.
* Data is queried using SQL (Structured Query Language).

**When to use:**
* When data structure is clear, consistent, and unlikely to change frequently.
* When data integrity, consistency, and transactional reliability are paramount (e.g., financial transactions, order management).
* When complex queries involving multiple joins are common.
* For OLTP (Online Transaction Processing) systems.
  * Examples: MySQL, PostgreSQL, Oracle, Microsoft SQL Server, SQLite.

### Non-Relational Databases (NoSQL Databases)

**How they work:**

* Do not rely on the traditional table-based relational model.
* Offer more flexible schemas (schema-less or dynamic schemas).
* Designed for specific data models and access patterns, often prioritizing scalability, flexibility, and speed over strict ACID compliance (though some offer eventual consistency).
* They are typically queried using non-SQL query languages or APIs specific to their data model.

**Types and When to use:**

* Key-Value Stores: (e.g., Redis, DynamoDB)
* Data is stored as key-value pairs. Simple, high performance for simple lookups.
* Use when: You need to store simple data with fast read/write access (e.g., caching, session management).
* Document Databases: (e.g., MongoDB, Couchbase)
* Data is stored in flexible, semi-structured "documents" (like JSON, XML).
* **Use when:** Data structure evolves rapidly, or data is hierarchical and needs to be stored together (e.g., user profiles, product catalogs, content management).
* Column-Family Stores: (e.g., Cassandra, HBase)
* Data is stored in rows, but columns are grouped into "column families." Highly scalable for wide tables.
* **Use when:** You have large datasets with many columns, where you often need to query specific columns, and high write throughput is required (e.g., time-series data, IoT data, fraud detection).
* Graph Databases: (e.g., Neo4j, Amazon Neptune)
* Data is stored as nodes (entities) and edges (relationships between entities).
Use when: Relationships between data points are as important as the data itself, and you need to traverse complex networks (e.g., social networks, recommendation engines, fraud detection).
Examples: MongoDB, Cassandra, Redis, DynamoDB, Neo4j.

### Key Differences & When to Use Each

| Feature | Relational Databases (SQL) | Non-Relational Databases (NoSQL) |
|---------|---------------------------|-----------------------------------|
| Schema | Predefined, rigid (schema-on-write) | Dynamic, flexible (schema-on-read) |
| Scalability | Primarily vertical (scaling up) with some horizontal | Primarily horizontal (scaling out) |
| Data Model | Tabular (rows & columns) with relationships | Various: Key-value, Document, Column, Graph |
| Query Language | SQL | API-based, object-based query languages |
| ACID | Strong ACID compliance | Often BASE (Basically Available, Soft State, Eventual Consistency) |
| Best For | Structured, transactional data; complex joins; data integrity | Unstructured/semi-structured data; high velocity/volume; flexible schemas; rapid development |


---

## Data Lake vs. Data Warehouse

These are architectural patterns for storing and managing large volumes of data for analytical purposes.

### Data Warehouse

**What it is:** A centralized repository of integrated data from one or more disparate sources. Data is transformed, cleaned, and structured into a schema (e.g., star or snowflake schema) before being loaded into the warehouse.

#### Characteristics

- **Schema-on-Write:** Data conforms to a schema upon ingestion.
- **Structured Data:** Primarily stores structured and semi-structured data.
- **Cleaned and Transformed:** Data is cleansed, aggregated, and optimized for analytical queries.
- **Historical Data:** Stores historical data for long-term analysis.
- **Optimized for Reporting & BI:** Designed for fast analytical queries and business intelligence tools.

#### When to use

- When you have a clear understanding of the data requirements and how it will be used for reporting and analysis.
- For traditional BI reporting, dashboards, and operational analytics.
- When data quality and consistency are paramount for reliable business insights.
- When data needs to be highly structured and integrated for predefined analytical questions.

#### Examples
AWS Redshift, Snowflake, Google BigQuery, Microsoft SQL Server Data Warehouse.

### Data Lake

**What it is:** A vast, centralized repository that stores a massive amount of raw data in its native format, regardless of its source or structure. Data is stored "as is" and transformed only when needed for specific analysis.

#### Characteristics

- **Schema-on-Read:** Data doesn't conform to a schema until it's read and processed for a specific use case.
- **Raw Data:** Stores all types of data – structured, semi-structured, and unstructured (text, audio, video).
- **Cost-Effective Storage:** Often built on cheap object storage (e.g., S3, ADLS).
- **Flexible & Agile:** Supports evolving data types and future, unforeseen analytical needs.
- **Supports Advanced Analytics:** Ideal for machine learning, data science, and big data processing.

#### When to use

- When you need to store vast amounts of diverse, raw data for future or evolving analytical needs.
- For advanced analytics, machine learning, predictive modeling, and real-time analytics.
- When the data schema is unknown or highly variable.
- When you want to retain all original data, even if its immediate use case is not defined.
- For exploring new patterns without rigid schema constraints.

#### Examples
AWS S3, Azure Data Lake Storage (ADLS), Google Cloud Storage (GCS) combined with processing engines like Apache Spark or Databricks.

### Key Differences & When to Use Each

# Database and Data Architecture Comparison Tables

| Feature | Data Warehouse | Data Lake |
|---------|---------------|-----------|
| Schema | Schema-on-Write (structured on ingestion) | Schema-on-Read (structure applied at query time) |
| Data Types | Structured, filtered, processed | Raw, all formats (structured, semi-structured, unstructured) |
| Data Quality | High, consistent, cleansed | Raw, potentially inconsistent |
| Purpose | Reporting, BI, historical analysis, predefined queries | Advanced analytics, ML, predictive modeling, data exploration |
| Flexibility | Less flexible, designed for specific analyses | Highly flexible, adaptable to new use cases |
| Users | Business analysts, BI professionals | Data scientists, data engineers, advanced analysts |

