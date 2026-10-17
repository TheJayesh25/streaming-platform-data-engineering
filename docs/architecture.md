# Architecture

## Overview

The pipeline follows a batch-oriented ELT architecture:

```text
MovieLens 20M
      │
      ▼
Amazon S3
      │
      │ Snowflake Storage Integration
      ▼
Snowflake RAW
      │
      │ dbt
      ▼
Snowflake STAGING
      │
      │ dbt transformations
      ▼
Snowflake MARTS
      │
      ├── Dimensions
      ├── Facts
      ├── Bridge
      └── Analytical Metrics
```

## Layer Responsibilities

### Amazon S3

Acts as the cloud-based landing location for the source CSV files.

### RAW

Contains source-aligned tables loaded from S3.

The raw layer is intentionally minimally transformed so that the source data
remains available for downstream processing.

### STAGING

Provides a standardized interface between the raw source and analytical
models.

Transformations are intentionally limited to:

- Column renaming
- Timestamp conversion
- Basic source-level standardization

### MARTS

Contains the analytical dimensional model.

The mart layer is organized logically into:

- Dimensions
- Facts
- Bridge tables
- Analytical metrics

All are physically materialized in the MARTS schema.

## Why ELT?

The project uses Snowflake as the transformation environment.

Instead of performing the majority of transformations before loading the
warehouse, source data is loaded into Snowflake first and transformed using
dbt.

This allows transformation logic to remain version-controlled, modular, and
testable.

## Materialization Strategy

### Staging

Staging models are materialized as views because they perform lightweight
standardization and do not require persistent copies of transformed data.

### Mart dimensions and facts

Core analytical models are materialized as tables because they form the
consumption layer of the warehouse.

### `fct_ratings`

The primary rating event fact is incremental to demonstrate efficient
processing of newly arrived data.

### `movie_rating_metrics`

Daily rating metrics are materialized as a table because the aggregation is
reused for analytical queries and does not need to be recalculated on every
query.