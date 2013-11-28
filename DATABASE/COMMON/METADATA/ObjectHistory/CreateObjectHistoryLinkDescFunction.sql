CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_JuridicalDetails_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'JuridicalDetails_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'JuridicalDetails_Bank','Банк' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_JuridicalDetails_Bank());


