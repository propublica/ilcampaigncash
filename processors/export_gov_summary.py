import json
import os
import records
import sys

from lib import GOV_COMMITTEES, PRE_PRIMARY_START, PRIMARY_START, PRIMARY_END, PRIMARY_QUARTERLY_END


def get_raised(committee_id, db):
    query = """
        SELECT d.*, f.*
        FROM d2totals d
        JOIN fileddocs f on d.fileddocid = f.id
        WHERE
            d.committeeid = :committee_id AND
            d.archived = false AND
            f.rptpdbegdate >= :start AND
            f.archived = false AND
            f.docname = 'Quarterly'
    """
    results = db.query(query, committee_id=committee_id, start=PRE_PRIMARY_START)

    total_raised = 0
    for row in results:
        total_raised += (row.totalreceipts + row.totalinkind)

    # import ipdb; ipdb.set_trace();

    return total_raised, 0, []


def export(db_url):
    db = records.Database(db_url)
    db.query("set schema 'raw'")

    out = []
    for candidate, incumbent, party, committee_id, img, include in GOV_COMMITTEES:

        raised, raised_30days, raised_timeline = get_raised(committee_id, db)

        out.append({
            'name': candidate,
            'party': party,
            'raised': raised,
            'raised_30days': raised_30days,
            'spent': 'TK',
            'cash_on_hand': 'TK',
            'img': img,
            'incumbent': incumbent,
            'raised_timeline': raised_timeline,
        })

    return out


if __name__ == '__main__':
    output = export(sys.argv[1])
    print(json.dumps(output), file=sys.stdout)
