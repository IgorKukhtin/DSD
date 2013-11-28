CREATE OR REPLACE FUNCTION zc_ObjectHistoryFloat_PriceListItem_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryFloatDesc WHERE Code = 'PriceListItem_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryFloatDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_PriceListItem(), 'PriceListItem_Value','Цена в прайс-листе' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());


