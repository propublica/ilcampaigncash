###############################################################################
#
# ILLINOIS STATE BOARD OF ELECTION CAMPAIGN FINANCE LOADER
#
# You must set some environment variables:
#
# export ILCAMPAIGNCASH_DB_NAME=ilcampaigncash
# export ILCAMPAIGNCASH_DB_URL=postgres://localhost/$ILCAMPAIGNCASH_DB_NAME
# export ILCAMPAIGNCASH_FTP_USER=ftpuser
# export ILCAMPAIGNCASH_FTP_PASSWD=ftppassword
#
###############################################################################

# Include .env configuration
include .env
export

# Activate Python environment
PIPENV = pipenv run

# Base files
TABLES = $(basename $(notdir $(wildcard sql/tables/*.sql)))

# Schemas
SCHEMAS = raw public

# Views
VIEWS = $(basename $(notdir $(wildcard sql/views/*.sql)))


##@ Basic usage

.PHONY: all
all: ## Build database
	@echo $(VIEWS)

.PHONY: download
download: $(patsubst %, data/download/%.txt, $(TABLES)) ## Download source data

.PHONY: process
process: $(patsubst %, data/processed/%.csv, $(TABLES)) ## Process source data

.PHONY: load
load: $(patsubst %, db/csv/%, $(TABLES)) ## Process load processed data

.PHONY: views
views: $(patsubst %, db/views/%, $(VIEWS)) ## Create views

.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z\%\\.\/_-]+:.*?##/ { printf "\033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Database views

define create_view
	(psql -c "\d public.$(subst db/views/,,$@)" > /dev/null 2>&1 && \
		echo "view public.$(subst db/views/,,$@) exists") || \
	psql -v ON_ERROR_STOP=1 -qX1ef $<
endef

.PHONY: db/views/%
db/views/%: sql/views/%.sql load  ## Create view % specified in sql/views/%.sql (will load all data)
	$(call create_view)

.PHONY: db/views/Condensed_Receipts
db/views/Condensed_Receipts: sql/views/Condensed_Receipts.sql db/views/Receipts db/views/Most_Recent_Filings
	$(call create_view)

.PHONY: db/views/Condensed_Expenditures
db/views/Condensed_Expenditures: sql/views/Condensed_Expenditures.sql db/views/Expenditures db/views/Most_Recent_Filings
	$(call create_view)

.PHONY: db/views/Most_Recent_Filings
db/views/Most_Recent_Filings: sql/views/Most_Recent_Filings.sql db/views/Committees db/views/Filed_Docs db/views/D2_Reports
	$(call create_view)

##@ Database structure

define create_extension
	@(psql -c "\dx $(subst db/extensions/,,$@)" | grep $(subst db/extensions/,,$@) > /dev/null 2>&1 && \
		echo "extension $(subst db/extensions/,,$@) exists") || \
	psql -v ON_ERROR_STOP=1 -qX1ec "CREATE EXTENSION $(subst db/extensions/,,$@)"
endef

define create_raw_table
	@(psql -c "\d raw.$(subst db/tables/,,$@)" > /dev/null 2>&1 && \
		echo "table raw.$(subst db/tables/,,$@) exists") || \
	psql -v ON_ERROR_STOP=1 -qX1ef $<
endef

define create_processed_table
	@(psql -c "\d processed.$(subst db/processed/,,$@)" > /dev/null 2>&1 && \
		echo "table processed.$(subst db/processed/,,$@) exists") || \
	psql -v ON_ERROR_STOP=1 -qX1ef $<
endef

define create_schema
	@(psql -c "\dn $(subst db/schemas/,,$@)" | grep $(subst db/schemas/,,$@) > /dev/null 2>&1 && \
	  echo "schema $(subst db/schemas/,,$@) exists") || \
	psql -v ON_ERROR_STOP=1 -qaX1ec "CREATE SCHEMA $(subst db/schemas/,,$@)"
endef

define load_raw_csv
	@(psql -Atc "select count(*) from raw.$(subst db/csv/,,$@)" | grep -v -w "0" > /dev/null 2>&1 && \
	 	echo "raw.$(subst db/csv/,,$@) is not empty") || \
	psql -v ON_ERROR_STOP=1 -qX1ec "\copy raw.$(subst db/csv/,,$@) from '$(CURDIR)/$<' with delimiter ',' csv header;"
endef

define create_function
	@(psql -c "\df $(subst db/functions/,,$@)" | grep $(subst db/functions/,,$@) > /dev/null 2>&1 && \
	 echo "function $(subst db/functions/,,$@) exists")	|| \
	 psql -v ON_ERROR_STOP=1 -qX1ef sql/functions/$(subst db/functions/,,$@).sql
endef

.PHONY: db
db: ## Create database
	@(psql -c "SELECT 1" > /dev/null 2>&1 && \
		echo "database $(PGDATABASE) exists") || \
	createdb -e $(PGDATABASE) -E UTF8 -T template0 --locale=en_US.UTF-8

.PHONY: db/extensions/%
db/extensions/%: db ## Create extension % (where % is 'hstore', 'postgis', etc)
	$(call create_extension)

.PHONY: db/vacuum
db/vacuum: # Vacuum db
	psql -v ON_ERROR_STOP=1 -qec "VACUUM ANALYZE;"

.PHONY: db/schemas
db/schemas: $(patsubst %, db/schemas/%, $(SCHEMAS)) ## Make all schemas

.PHONY: db/schemas/%
db/schemas/%: db # Create schema % (where % is 'raw', etc)
	$(call create_schema)

.PHONY: db/functions
db/functions: $(patsubst %, db/functions/%, $(FUNCTIONS)) ## Make all functions

.PHONY: db/functions/%
db/functions/%: db
	$(call create_function)

.PHONY: db/searchpath
db/searchpath: db/schemas # Set up (hardcoded) schema search path
	psql -v ON_ERROR_STOP=1 -qX1c "ALTER DATABASE $(PGDATABASE) SET search_path TO public,views,processed,raw;"

.PHONY: db/tables/%
db/tables/%: sql/tables/%.sql db/searchpath # Create table % from sql/tables/%.sql
	$(call create_raw_table)

.PHONY: db/csv/%
db/csv/%: data/processed/%.csv db/tables/% # Load table % from data/downloads/%.csv
	$(call load_raw_csv)

.PHONY: db/processed/%
db/processed/%: sql/processed/%.sql db/functions db/schemas # Make table cleaned and processed tables
	$(call create_processed_table)

.PHONY: dropschema/%
dropschema/%: # @TODO wrap in detection
	psql -v ON_ERROR_STOP=1 -qX1c "DROP SCHEMA IF EXISTS $* CASCADE;"

.PHONY: dropdb
dropdb: ## Drop database
	dropdb --if-exists -e $(PGDATABASE)


##@ Data processing

data/download/%.txt: ## Download %.txt (where % is something like Candidates)
	aria2c -x5 -q -d data/download --ftp-user="$(ILCAMPAIGNCASH_FTP_USER)" --ftp-passwd="$(ILCAMPAIGNCASH_FTP_PASSWD)" ftp://ftp.elections.il.gov/CampDisclDataFiles/$*.txt

data/processed/%.csv: data/download/%.txt  ## Convert data/download/%.txt to data/processed/%.csv
	$(PIPENV) python processors/clean_isboe_tsv.py $< $* > $@


##@ Maintenance

.PHONY: install
install:  ## Install dependencies
	pipenv install

.PHONY: dbshell
dbshell: ## Run a database shell
	psql

.PHONY: clean
clean: clean/processed clean/download  ## Delete downloads and processed data files

.PHONY: clean/%
clean/%:  ## Clean data/%
	rm -f data/$*/*