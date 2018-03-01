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

TABLES = Candidates CanElections CmteCandidateLinks CmteOfficerLinks Committees D2Totals Expenditures FiledDocs Investments Officers PrevOfficers Receipts
SUMMARY_PATH = /Users/DE-Admin/Code/il-campaign-widget/src/data


.PHONY: all clean process load create_tables create_views download

all : db/init sql_init create_tables process load create_views sql_finalize
download : $(patsubst %, data/%.txt, $(TABLES))
create_tables : $(patsubst %, create_table_%, $(TABLES))
create_views : $(patsubst %, create_view_%, $(TABLES)) create_view_Sunshine
process : $(patsubst %, data/processed/%.csv, $(TABLES))
load : $(patsubst %, db/%, $(TABLES))


define check_raw_relation
 psql $(ILCAMPAIGNCASH_DB_URL) -c "\d raw.$*" > /dev/null 2>&1 ||
endef


define check_public_relation
 psql $(ILCAMPAIGNCASH_DB_URL) -c "\d public.$*" > /dev/null 2>&1 ||
endef


db/init	:
	createdb $(ILCAMPAIGNCASH_DB_NAME)
	touch $@


db/drop : db/init
	dropdb $(ILCAMPAIGNCASH_DB_NAME) || touch /dev/null
	rm -f db/*


data/download/%.txt :
	aria2c -x5 -q -d data/download --ftp-user="$(ILCAMPAIGNCASH_FTP_USER)" --ftp-passwd="$(ILCAMPAIGNCASH_FTP_PASSWD)" ftp://ftp.elections.il.gov/CampDisclDataFiles/$*.txt


db/% : data/processed/%.csv
	psql $(ILCAMPAIGNCASH_DB_URL) -c "\copy raw.$* from '$(CURDIR)/$<' with delimiter ',' csv header;"
	touch db/$*


sql_% : sql/%.sql
	psql $(ILCAMPAIGNCASH_DB_URL) -f $<


create_table_% : sql/tables/%.sql
	$(check_raw_relation) psql  $(ILCAMPAIGNCASH_DB_URL) -f $<


create_view_% : sql/views/%.sql
	$(check_public_relation) psql $(ILCAMPAIGNCASH_DB_URL) -f $<


data/processed/%.csv : data/download/%.txt
	python processors/clean_isboe_tsv.py $< $* > $@


clean : db/drop
	rm -f data/processed/*
	rm -f data/download/*
