
CREATE OR REPLACE FUNCTION zc_MIBoolean_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Child', 'корректировка прошла, данные перенесены из Child' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Child'); 

CREATE OR REPLACE FUNCTION zc_MIBoolean_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Master', 'корректировка прошла, данные перенесены из Master' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Master'); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  15.01.22        *
  08.01.22                                        *
*/
