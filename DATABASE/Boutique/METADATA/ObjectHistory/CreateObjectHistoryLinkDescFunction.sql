CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_JuridicalDetails_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'zc_ObjectHistoryLink_JuridicalDetails_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryLink_JuridicalDetails_Bank','����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_JuridicalDetails_Bank());

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.12.13                                        * !!!rename!!!
*/
