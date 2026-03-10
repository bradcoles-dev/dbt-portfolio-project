# dbt Portfolio Project

A portfolio project exploring dbt (data build tool) with the NYC Yellow Taxi dataset, using DuckDB as the local warehouse.

---

## Architecture

This project follows the **medallion architecture**, which is standard in enterprise data platforms regardless of tooling.

```
Bronze  →  Silver  →  Gold
  ↓           ↓         ↓
Seeds /    Staging    Marts
Sources    (stg_)   (fct_, dim_)
```

| Layer | dbt folder | Purpose |
|---|---|---|
| Bronze | `seeds/` or sources | Raw data, untouched |
| Silver | `models/staging/` | Clean, rename, cast types |
| Gold | `models/marts/` | Joins, aggregations, business logic |

---

## dbt vs Spark Notebooks for Batch Transformations

This project emerged from experience implementing enterprise-level **MS Fabric** solutions using metadata-driven Spark notebooks for batch ingestion and transformation. dbt is being evaluated as an alternative for the transformation layer.

### Comparison

| | Spark Notebooks | dbt |
|---|---|---|
| Transformation language | PySpark / SQL | SQL only |
| Metadata-driven | Custom-built framework required | Built-in (schema.yml, sources) |
| Lineage tracking | Manual / external tools | Automatic DAG |
| Data testing | Custom-written | Built-in test framework |
| Documentation | Custom-built | Auto-generated |
| Version control | Notebooks (difficult to diff) | Plain SQL files (clean) |
| Learning curve | High | Low |
| Compute engine | Spark cluster | Warehouse engine |

### Conclusion

For **batch, structured SQL transformations**, dbt is the better choice:

- Testing, documentation, and lineage come out of the box — no custom framework needed
- Plain SQL files are easier to version control and review than notebooks
- The metadata-driven pattern that teams build manually in Spark is dbt's default behaviour

Spark remains the right tool for:

- Unstructured or semi-structured data processing
- ML pipelines and Python-heavy logic
- Streaming / near-real-time ingestion

### Recommended pattern for MS Fabric

```
Ingestion (Fivetran / ADF / Spark notebooks)
        ↓
    Bronze layer  ←  raw Lakehouse/Warehouse tables
        ↓
    Silver layer  ←  dbt staging models (clean, type, dedupe)
        ↓
    Gold layer    ←  dbt mart models (joins, aggregations)
        ↓
    Power BI / reporting layer
```

dbt owns the silver and gold layers. Spark notebooks are retained only where Python or unstructured data processing is required.

---

## Project Structure

```
taxi_project/
├── seeds/
│   └── raw_yellow_taxi.csv       # Sample NYC taxi data (bronze)
├── models/
│   ├── staging/
│   │   ├── stg_yellow_taxi.sql   # Clean and rename raw trips (silver)
│   │   └── schema.yml            # Column descriptions and tests
│   └── marts/
│       └── fct_trips_by_day.sql  # Daily trip aggregations (gold)
├── dbt_project.yml
└── profiles.yml                  # Connection config (in ~/.dbt/)
```

## Stack

- **dbt-core** 1.11.7
- **dbt-duckdb** 1.10.1
- **DuckDB** 1.4.4 (local warehouse, no cloud account required)

## Running the project

```bash
dbt seed      # Load raw CSV data
dbt run       # Build staging and mart models
dbt test      # Run data quality tests
dbt docs generate && dbt docs serve   # View lineage graph and docs
```
