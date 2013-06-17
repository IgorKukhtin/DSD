insert into ObjectHistoryDesc(Id, Code, ItemName)
SELECT zc_ObjectHistory_PriceListItem(), 'PriceListItem', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_PriceListItem());

