
CREATE OR REPLACE FUNCTION zc_ObjectHistory_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
   SELECT 'zc_ObjectHistory_PriceListItem', '�����-����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_PriceListItem());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_JuridicalDetails() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_JuridicalDetails'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
   SELECT 'zc_ObjectHistory_JuridicalDetails', '��������� ����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_JuridicalDetails());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_DiscountPeriodItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_DiscountPeriodItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
   SELECT 'zc_ObjectHistory_DiscountPeriodItem', '�������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_DiscountPeriodItem());

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 28.04.17         * add zc_ObjectHistory_DiscountPeriodItem
 22.12.15                                                          *zc_ObjectHistory_Price
 15.12.13                                        * !!!rename!!!
*/
