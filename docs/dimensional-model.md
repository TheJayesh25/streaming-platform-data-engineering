# Dimensional Model

## Modeling Approach

The mart layer follows dimensional modeling principles.

Each model was defined by its grain before determining its columns or
relationships.

The design separates:

- Descriptive entities
- Behavioral events
- Many-to-many relationships
- Content characteristics
- Reusable analytical aggregates

---

## Dimensions

### `dim_movies`

**Grain:** One row per movie.

Contains:

- Movie identifier
- Standardized title
- IMDb identifier
- TMDB identifier

Movie genres are intentionally not stored as a single attribute because a
movie can belong to multiple genres.

---

### `dim_users`

**Grain:** One row per observed MovieLens user.

MovieLens does not provide a user profile dataset containing demographic or
behavioral attributes suitable for this model.

Therefore, the dimension only represents the user entity.

No demographic attributes are inferred or invented.

Users are derived from rating and tagging activity.

---

### `dim_genres`

**Grain:** One row per genre.

The source `genres` column contains pipe-delimited values such as:

`Action|Adventure|Sci-Fi`

These values are normalized into individual genre records.

---

### `dim_genome_tags`

**Grain:** One row per genome tag.

Genome tags represent content characteristics and are conceptually different
from user-generated movie tags.

---

## Fact Tables

### `fct_ratings`

**Grain:** One rating submitted by one user for one movie at one timestamp.

This is the primary behavioral fact in the model.

Measures include:

- Rating

Dimensions can be associated through:

- User
- Movie
- Time derived from the rating timestamp

---

### `fct_movie_tags`

**Grain:** One user-generated tag applied to one movie at one timestamp.

This represents user-generated content metadata and tagging activity.

It is kept separate from ratings because a tag event has different semantics
from a rating event.

---

### `fct_genome_tag_relevance`

**Grain:** One movie × genome-tag relationship.

The primary measure is:

- Relevance score

This represents content characteristics rather than user behavior.

---

## Bridge Table

### `bridge_movie_genres`

**Grain:** One movie × genre relationship.

A movie can belong to multiple genres and a genre can describe multiple
movies.

Therefore:

```text
Movie ───< Movie Genre >─── Genre
```

The bridge resolves the many-to-many relationship without storing a
multi-valued genre field in the movie dimension.

---

## Analytical Mart

### `movie_rating_metrics`

**Grain:** One movie per calendar date with at least one rating.

Metrics include:

- Rating count
- Unique raters
- Average rating
- Minimum rating
- Maximum rating

The model converts event-level ratings into a reusable daily analytical
dataset.

One important semantic consideration is that `unique_raters` is unique within
the movie/date grain. Summing it across multiple dates does not produce the
number of distinct users across the entire period.