class ISBOEModel(object):
    def __init__(self, row):
        self.row = row
        self.validate()

    def validate(self):
        """
        Must raise errors for invalid rows
        """
        raise NotImplementedError

    def clean(self, row):
        return {k: v.strip() for k, v in row.items() if k and v}

    def serialize(self):
        return self.clean(self.row)


class Candidate(ISBOEModel):
    def validate(self):
        pass


class CanElection(ISBOEModel):
    def validate(self):
        pass


class CmteCandidateLink(ISBOEModel):
    def validate(self):
        pass


class CmteOfficerLink(ISBOEModel):
    def validate(self):
        pass


class Committee(ISBOEModel):
    def validate(self):
        pass


class D2Total(ISBOEModel):
    def validate(self):
        pass


class Expenditure(ISBOEModel):
    def validate(self):
        pass


class FiledDoc(ISBOEModel):
    def validate(self):
        pass


class Investment(ISBOEModel):
    def validate(self):
        pass


class Officer(ISBOEModel):
    def validate(self):
        pass
        # int(self.row['CommitteeID'])


class PrevOfficer(ISBOEModel):
    def validate(self):
        pass


class Receipt(ISBOEModel):
    def validate(self):
        # Some rows are shifted
        int(self.row['ID'])
        int(self.row['CommitteeID'])
