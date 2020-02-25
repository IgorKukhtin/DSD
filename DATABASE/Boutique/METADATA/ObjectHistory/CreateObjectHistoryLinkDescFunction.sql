
CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_JuridicalDetails_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'zc_ObjectHistoryLink_JuridicalDetails_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryLink_JuridicalDetails_Bank','Банк' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_JuridicalDetails_Bank());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_PriceListItem_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'zc_ObjectHistoryLink_PriceListItem_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
   SELECT zc_ObjectHistory_PriceListItem(), 'zc_ObjectHistoryLink_PriceListItem_Currency','Валюта' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_PriceListItem_Currency());


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.20         * zc_ObjectHistoryLink_PriceListItem_Currency
 15.12.13                                        * !!!rename!!!
*/
