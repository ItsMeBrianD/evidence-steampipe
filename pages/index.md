# Evidence + Steampipe Demo

The goal of this example is to show how Steampipe can be connected to a Postgres database to enrich what can be displayed in an Evidence project.

Steampipe is built on Postgres, and translates SQL to API calls for over 100 popular APIs.  
Evidence is a Business Intelligence as Code framework, using markdown + sql to make it easy to build rich reports and analyses.

This demo is built with a single Postgres Database, Steampipe Database, and Evidence, and will only work if your provider supports the `postgres_fdw` extension. 
If your provider doesn't - don't worry, support for multiple connections in a single evidence project is coming (soon).

Postgres is configured to use the `postgres_fdw` extension to connect to the Steampipe database; while you can also use Steampipe directly, this allows you to leverage Steampipe from an existing Postgres database.

Steampipe is connected to Github using the [Github Plugin](https://hub.steampipe.io/plugins/turbot/github).

## Running Total Stargazers over Time
```gazers
WITH
  stargazers AS (
    SELECT
      COUNT(*) as gazers,
      date_trunc('month', starred_at) as starred_at
    FROM
      steampipe_github.github_stargazer
    WHERE
      repository_full_name = 'evidence-dev/evidence'
    GROUP BY
      date_trunc('month', starred_at)
  )
SELECT *,
  SUM(gazers) OVER (order by date_trunc('month', starred_at) asc rows between unbounded preceding and current row) total_gazers
FROM stargazers
  ;
```

This chart shows the new stargazers by month, along with a running total. The data here is pulled from steampipe.

<Chart data={gazers} x="starred_at">
    <Bar y="gazers"/>
    <Line y="total_gazers"/>
</Chart>

## Most films by Category

```films_by_category
SELECT COUNT(*) as films, category.name as category FROM film_category
	INNER JOIN film on film_category.film_id = film.film_id
  INNER JOIN category on film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY 1 desc
LIMIT 5
```

This chart contains the number of films by their category; which is data stored directly in Postgres

You can download the demo dataset from [postgresqltutorial.com](https://www.postgresqltutorial.com/postgresql-getting-started/load-postgresql-sample-database/)

<BarChart data={films_by_category} y=films x=category series=category/>

## Interoperability

As an (admittedly very contrived) example, we can query the number of films (from our database), and the number of stargazers (from Steampipe) in the same query

```contrived_example
WITH 
  film_count as ( SELECT COUNT(*) AS film_count FROM film ),
  gazer_count as ( SELECT COUNT(*) as gazer_count FROM steampipe_github.github_stargazer WHERE repository_full_name = 'evidence-dev/evidence' )
SELECT 
  film_count.film_count,
  gazer_count.gazer_count 
FROM film_count
  CROSS JOIN gazer_count
```

<BigValue data={contrived_example} value=film_count />
<BigValue data={contrived_example} value=gazer_count />
