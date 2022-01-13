
CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_PriceListItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryFloat_PriceListItem_Value','���� � �����-�����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_ServiceItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_ServiceItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_ServiceItem(), 'zc_ObjectHistoryFloat_ServiceItem_Value','����� �� �������, ��.�.' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_ServiceItem_Value());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_ServiceItem_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_ServiceItem_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_ServiceItem(), 'zc_ObjectHistoryFloat_ServiceItem_Price','���� �� ��.�.' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_ServiceItem_Price());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_ServiceItem_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'zc_ObjectHistoryFloat_ServiceItem_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_ServiceItem(), 'zc_ObjectHistoryFloat_ServiceItem_Area','�������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_ServiceItem_Area());


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.22         * zc_ObjectHistoryFloat_ServiceItem_Area
                    zc_ObjectHistoryFloat_ServiceItem_Price
                    zc_ObjectHistoryFloat_ServiceItem_Value
 28.08.20                                        * 
*/
