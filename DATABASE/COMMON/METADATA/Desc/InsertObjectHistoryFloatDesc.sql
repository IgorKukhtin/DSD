INSERT INTO ObjectHistoryFloatDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectHistoryFloat_PriceListItem_Value(), zc_ObjectHistory_PriceListItem(), 'PriceListItem_Value','Цена в прайс-листе' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryFloatDesc WHERE Id = zc_ObjectHistoryFloat_PriceListItem_Value());


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
