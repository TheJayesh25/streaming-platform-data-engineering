# Design Decisions

This document records the main modeling and engineering decisions made during
the project.

The goal is to document not only what was implemented, but why.

---

## 1. Why MovieLens?

MovieLens 20M provides a sufficiently rich public dataset containing:

- Movies
- Ratings
- User-generated tags
- Genre information
- Genome tags
- Genome relevance scores
- External movie identifiers

This allows the project to demonstrate ingestion, dimensional modeling,
fact design, many-to-many relationships, incremental processing, and data
quality without requiring proprietary data.

The dataset is treated as a representative streaming-platform source rather
than as Netflix data.

---

## 2. Why Separate RAW, STAGING and MARTS?

The layers have distinct responsibilities.

### RAW

Preserve the source representation.

### STAGING

Standardize source data and provide a stable interface to downstream models.

### MARTS

Apply analytical business logic and dimensional modeling.

This separation makes transformation responsibilities explicit and prevents
business logic from being mixed directly into source ingestion.

---

## 3. Why Are Genres Normalized?

The source movie table stores genres as a pipe-delimited string.

For example:

```text
Action|Adventure|Sci-Fi
```

Keeping this value as a single column would make genre-level analysis less
convenient and would represent a multi-valued attribute inside a single
relational column.

The model therefore creates:

```text
dim_genres
      │
      │
bridge_movie_genres
      │
      │
dim_movies
```

This produces a relational representation of the many-to-many relationship.

---

## 4. Why Is There No dim_links?

IMDb and TMDB identifiers are attributes of a movie rather than independent
analytical entities.

They therefore enrich `dim_movies` instead of requiring a separate dimension.

---

## 5. Why Are User Tags and Genome Tags Separate?

They represent different concepts.

### User-generated tags

Created by MovieLens users and represent explicit user activity or metadata.

### Genome tags

Part of the MovieLens content-characterization system and are associated with
movies through relevance scores.

Combining them would blur the semantic distinction between user-generated
activity and content characteristics.

---

## 6. Why Is fct_ratings an Event Fact?

A rating represents an event:

> A user rated a movie at a specific point in time.

The event grain preserves the original behavioral information and allows
downstream analysis by user, movie and time.

Aggregating ratings too early would remove useful analytical detail.

---

## 7. Why Is movie_rating_metrics a Separate Model?

The raw rating fact is useful for detailed analysis, but common analytical
questions repeatedly require aggregating ratings by movie and date.

`movie_rating_metrics` provides a reusable analytical representation with the
grain:

> One movie × calendar date.

This avoids repeatedly calculating the same aggregation during downstream
analysis.

---

## 8. Why Use an Incremental Model?

`fct_ratings` is the largest behavioral fact and represents append-oriented
rating events.

An incremental model demonstrates how newly arriving events can be processed
without rebuilding the entire target table.

The current implementation uses the maximum existing rating timestamp as a
watermark.

This is intentionally simple.

### Known limitation

A late-arriving record with a timestamp older than the current watermark would
not be captured by the current logic.

A production implementation could use a lookback window, ingestion timestamp,
source batch identifier, or another CDC/incremental strategy depending on the
source system.

---

## 9. Why No dbt Snapshot?

Snapshots were evaluated but not implemented.

The available source data does not provide a strong business requirement for
tracking historical versions of mutable records.

Ratings and tags are naturally represented as events, while MovieLens movie
metadata and genome relevance data are effectively static for this use case.

Adding a snapshot purely to demonstrate the feature would introduce
complexity without solving a real analytical requirement.

---

## 10. Why No SCD Type 2?

The same reasoning applies to SCD Type 2.

The project does not contain a changing descriptive entity for which historical
attribute states are analytically important.

Implementing SCD Type 2 would therefore be demonstrating a technique rather
than solving a requirement.

---

## 11. Why Keep All Mart Models in One Snowflake Schema?

The models have different logical roles, but they collectively form the
analytical presentation layer.

Therefore:

```text
MOVIELENS.MARTS
```

contains the dimensions, facts, bridge and analytical metrics.

The dbt repository uses folders to communicate logical organization without
creating unnecessary physical Snowflake schemas.

---

## 12. Why Tables Instead of Views for the Marts?

Mart models are intended to be reusable analytical datasets.

Persisting them as tables avoids recalculating their transformations for every
downstream query.

Staging models remain views because they perform lightweight source
standardization.

---

## 13. Why No Snapshot / CDC / Streaming Architecture?

These capabilities are outside the requirements of the current batch
analytical use case.

The project is intentionally focused on:

```text
S3 → Snowflake → dbt → Analytical Warehouse
```

rather than introducing additional technologies purely to increase the
technology count.