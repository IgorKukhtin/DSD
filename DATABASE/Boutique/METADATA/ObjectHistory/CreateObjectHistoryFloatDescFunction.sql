
CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceListItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_PriceListItem_Value','���� � �����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_DiscountPeriodItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_DiscountPeriodItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_DiscountPeriodItem(), 'zc_ObjectHistoryFloat_DiscountPeriodItem_Value','% �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_DiscountPeriodItem_Value());


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 28.04.17         * add zc_ObjectHistoryFloat_DiscountPeriodItem_Value
 24.02.16         * add zc_ObjectHistoryFloat_Price_MCSPeriod
                      , zc_ObjectHistoryFloat_Price_MCSDay
 22.12.15                                                          *zc_ObjectHistoryFloat_Price_Value,zc_ObjectHistoryFloat_Price_MCSValue
 15.12.13                                        * !!!rename!!!
*/
