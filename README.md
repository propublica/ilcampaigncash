# Illinois Campaign Cash loader

Load Illinois campaign fundraising data from the Illinois State Board of Elections.

## Requirements

* GNU Make
* PostgreSQL (all versions > 9.x should work)
* Python 3 (tested on 3.6 and 3.7)
* [Aria2](https://aria2.github.io/)
* FTP access to Illinois State Board Of Elections Data

## Install

Some kind of Python environment tool (e.g. [pipenv](https://docs.pipenv.org/) or [virtualenv](https://virtualenv.pypa.io/en/stable/)) is highly recommended but not required.

Pipenv is preferred. To use Pipenv, install with:

```
pipenv install
```

You can also install using the `requirements.txt` file:

```
pip install -r requirements.txt
```

## Configure

You'll need to create a `.env` file with configuration variables.

```
ILCAMPAIGNCASH_FTP_USER=<your-ftp-username>
ILCAMPAIGNCASH_FTP_PASSWORD=<your-ftp-password>

PGHOST=<your-database-host>
PGPORT=<your-database-port>
PGDATABASE=<your-database-name>
PGUSER=<your-database-username>
PGPASSWORD=<your-database-password>
```

The first two variables, `ILCAMPAIGNCASH_FTP_USER` and `IL_CAMPAIGNCASH_FTP_PASSWORD`, are required.

The `PG*` variables are standard [libpq environment variables](https://www.postgresql.org/docs/current/libpq-envars.html) and will vary based on your configuration. But many users will be fine simply using the variables specified above.

## Loading the data

Check out `Makefile` for all possible tasks.

### See high-level tasks

```
make help
```

### Load all

Download, process, and load.

```
make all
```

### Clean

Wipes database and files.

```
make clean
```

### Download

Download the latest data.

```
make download
```

## Advanced usage

### Drop schemas individually to re-run processing steps

Because transformed data and raw data exist in separate schemas, re-processing can be accomplished by dropping either or both schemas.

For example, if you want to change how the raw data is processed into the final public tables, you can do this:

```
make dropschema/public
make all
```

### Paralellization

Because of quirks with Make's parallelization model, you have to explicitly parallelize for steps that support it:

This incantation should do the trick. It parallelizes downloading and data loading across 4 cores, while running database creation and view creation serially.

```
make -j4 download && make db db/schemas && make -j4 load && make views
```

## Notes

"Views" are currently actually transformed copies of the tables from the `raw` schema, copied into the `public` schema. For performance reasons, these views are best expressed as materialized views. But because this database is intended to be accessed by Hasura, which doesn't yet support materialized views, we currently use straight copies. They are called views in this system in anticipation of materialized view support by Hasura and to convey their function, even if the underlying implementation isn't a "real" view.

## How it works

This loader mimics the [Illinois Sunshine](https://illinoissunshine.org/) extract-transform-load process.

It uses the efficient Postgres `COPY` command to load the raw data into a Postgres schema called `raw`. The raw tables are then cleaned and copied as materialized views into a `public` schema which substantially matches the Illinois Sunshine data model.

The loader does NOT handle updates, though it could be adapted to. However, this is not recommended. Inserts are faster than updates and somewhat easier to parallelize, and static builds are cheaper and more reliable than dynamic sites. The data itself is only updated daily at the time of writing.

Because we use a static build process, the created tables are currently not optimized as a few seconds difference in query performance has no impact on client performance. If that's something you need, please add it and send a pull request.
