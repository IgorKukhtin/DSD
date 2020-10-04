CREATE OR REPLACE FUNCTION zc_MIFloat_OperPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_OperPrice', 'Цена' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CountForPrice', 'Цена за количество' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                        * 
*/
