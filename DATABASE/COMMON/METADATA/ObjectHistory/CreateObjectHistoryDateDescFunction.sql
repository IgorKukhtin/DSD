
CREATE OR REPLACE FUNCTION zc_ObjectHistoryDate_JuridicalDetails_Decision() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDateDesc WHERE Code = 'zc_ObjectHistoryDate_JuridicalDetails_Decision'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDateDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryDate_JuridicalDetails_Decision','���� ������ ��� ������ ����糿' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDateDesc WHERE Id = zc_ObjectHistoryDate_JuridicalDetails_Decision());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryDate_PriceChange_FixEndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDateDesc WHERE Code = 'zc_ObjectHistoryDate_PriceChange_FixEndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDateDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceChange(), 'zc_ObjectHistoryDate_PriceChange_FixEndDate', '���� ��������� �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDateDesc WHERE Id = zc_ObjectHistoryDate_PriceChange_FixEndDate());

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   ������ �.�.
 20.04.21                                                                        * 
 06.03.17         * 
*/
