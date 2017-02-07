CREATE OR REPLACE FUNCTION zc_ObjectCost_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostDesc WHERE Code = 'zc_ObjectCost_Basis'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostDesc (Code, ItemName)
  SELECT 'zc_ObjectCost_Basis', 'Базовый расчет себестоимости' WHERE NOT EXISTS (SELECT * FROM ObjectCostDesc WHERE Code = 'zc_ObjectCost_Basis');


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.13                                        *
*/
