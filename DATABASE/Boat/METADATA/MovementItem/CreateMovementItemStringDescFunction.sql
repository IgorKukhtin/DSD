
CREATE OR REPLACE FUNCTION zc_MIString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Comment', 'Примечание' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment');

CREATE OR REPLACE FUNCTION zc_MIString_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_BarCode', 'Штрих-код поставщика' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_BarCode');

CREATE OR REPLACE FUNCTION zc_MIString_PartNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_PartNumber', '№ по тех паспорту' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartNumber');




/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 24.02.21         * zc_MIString_PartNumber
 25.05.17                                                         *
 10.05.17         * zc_MIString_BarCode
*/
