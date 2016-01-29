CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceListItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_PriceListItem_Value','���� � �����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_Price_Value','���� � �����-����� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_Price_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_Price_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_Price_MCSValue','��� ������ �� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_Price_MCSValue());

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 22.12.15                                                          *zc_ObjectHistoryFloat_Price_Value,zc_ObjectHistoryFloat_Price_MCSValue
 15.12.13                                        * !!!rename!!!
*/
