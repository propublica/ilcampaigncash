CREATE TABLE public.d2_reports
AS
  SELECT
    id as id,
    committeeid as committee_id,
    fileddocid as filed_doc_id,
    begfundsavail as beginning_funds_avail,
    indivcontribi as individual_itemized_contrib,
    indivcontribni as individual_non_itemized_contrib,
    xferini as transfer_in_itemized,
    xferinni as transfer_in_non_itemized,
    loanrvci as loan_received_itemized,
    loanrcvni as loan_received_non_itemized,
    otherrcti as other_receipts_itemized,
    otherrctni as other_receipts_non_itemized,
    totalreceipts as total_receipts,
    inkindi as inkind_itemized,
    inkindni as inkind_non_itemized,
    totalinkind as total_inkind,
    xferouti as transfer_out_itemized,
    xferoutni as transfer_out_non_itemized,
    loanmadei as loan_made_itemized,
    loanmadeni as loan_made_non_itemized,
    expendi as expenditures_itemized,
    expendni as expenditures_non_itemized,
    independentexpi as independent_expenditures_itemized,
    independentexpni as independent_expenditures_non_itemized,
    totalexpend as total_expenditures,
    debtsi as debts_itemized,
    debtsni as debts_non_itemized,
    totaldebts as total_debts,
    totalinvest as total_investments,
    endfundsavail as end_funds_available,
    archived as archived
  FROM raw.d2totals
;


ALTER TABLE public.d2_reports ADD PRIMARY KEY (id);