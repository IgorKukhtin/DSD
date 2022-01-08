CREATE OR REPLACE FUNCTION zc_MovementDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Insert', 'Дата/время создания' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert');

CREATE OR REPLACE FUNCTION zc_MovementDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Update', 'Дата/время корректировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update');
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.01.22                                        *
*/
