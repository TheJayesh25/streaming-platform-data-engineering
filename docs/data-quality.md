# Data Quality

Data quality is treated as part of the transformation pipeline rather than
as a separate manual validation step.

## Generic dbt Tests

The project uses:

- `not_null`
- `unique`
- `relationships`

These tests validate basic structural assumptions and referential integrity.

Examples include:

- Movie identifiers are unique.
- User identifiers are unique.
- Fact foreign keys resolve to their corresponding dimensions.
- Genre relationships resolve correctly.

---

## Singular Business Tests

The project also contains custom SQL tests for rules that generic dbt tests
cannot fully express.

### Rating validity

Ratings must fall within the MovieLens rating scale:

```text
0 ≤ rating ≤ 5
```

### Genome relevance validity

Genome relevance scores must satisfy:

```text
0 ≤ relevance_score ≤ 1
```

### Movie/genre uniqueness

A movie and genre pair should occur only once in the bridge table.

### Daily metrics grain

There must be no duplicate:

```text
(rating_date, movie_id)
```

combination in `movie_rating_metrics`.

### Metric reconciliation

The sum of daily `rating_count` values must reconcile with the total number
of rows in `fct_ratings`.

This validates that the aggregation has not lost or duplicated rating events.

---

## Validation Result

The final dbt build completed successfully:

```text
PASS=72
WARN=0
ERROR=0
SKIP=0
```

The build included:

- 1 incremental model
- 8 table models
- 6 staging views
- 57 data tests

---

## Testing Philosophy

The tests are designed around the model's assumptions rather than simply
maximizing test count.

For example, a relationship test answers:

> Does every fact reference an existing dimension record?

A grain test answers:

> Does this model actually contain the number of rows implied by its stated
> grain?

A reconciliation test answers:

> Did the transformation preserve the underlying event population?

These tests therefore validate both technical integrity and
analytical correctness.