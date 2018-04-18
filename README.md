# Illinois Campaign Cash loader

Loads Illinois campaign fundraising data.

## Requirements

* GNU Make
* PostgreSQL
* Python 3
* [Aria2c](https://aria2.github.io/)
* FTP access to Illinois State Board Of Elections Data

## Install

Some kind of Python environment tool (e.g. [pipenv](https://docs.pipenv.org/) or [virtualenv](https://virtualenv.pypa.io/en/stable/)) is highly recommended but not required.

```
pip install -r requirements.txt
```

## Configure

You'll need to export or set some environment variables:

```
export ILCAMPAIGNCASH_FTP_USER=<USERNAME>
export ILCAMPAIGNCASH_FTP_PASSWD=<PASSWORD>
export ILCAMPAIGNCASH_DB_NAME=ilcampaigncash
export ILCAMPAIGNCASH_DB_ROOT_URL=postgres://localhost:5432/postgres
export ILCAMPAIGNCASH_DB_URL=postgres://localhost:5432/ilcampaigncash
```

## Loading the data

Check out `Makefile` for all possible tasks.

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

Because of Make's weird parallelization model, loading in parallel requires multiple steps.

```
make create_db sql_init create_tables create_views && make -j 4 load_data
```

This incantation creates the database and then loads each table in four parallel processes. Because the expenditure and receipts tables are orders of magnitude larger than any others, the performance increase isn't significant.

## How it works

This loader mimics the [Illinois Sunshine](https://illinoissunshine.org/) extract-transform-load process.

It uses the efficient Postgres `COPY` command to load the raw data into a Postgres schema called `raw`. The raw tables are then cleaned and copied as materialized views into a `public` schema which substantially matches the Illinois Sunshine data model.

The loader does NOT handle updates, though it could be adapted to. However, this is not recommended. Inserts are faster than updates and somewhat easier to parallelize, and static builds are cheaper and more reliable than dynamic sites. The data itself is only updated daily at the time of writing.

Because we use a static build process, the created tables are currently not optimized as a few seconds difference in query performance has no impact on client performance. If that's something you need, please add it and send a pull request.
