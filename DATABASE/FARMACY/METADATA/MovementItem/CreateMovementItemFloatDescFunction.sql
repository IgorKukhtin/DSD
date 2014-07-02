CREATE OR REPLACE FUNCTION zc_MIFloat_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Summ', 'Сумма' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.07.14                                                       *
*/
