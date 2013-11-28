CREATE OR REPLACE FUNCTION zc_ObjectHistory_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'PriceListItem', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_PriceListItem());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_JuridicalDetails() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'JuridicalDetails'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'JuridicalDetails', 'Реквизиты юридических лиц' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_JuridicalDetails());
