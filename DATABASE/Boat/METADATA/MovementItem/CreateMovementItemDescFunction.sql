CREATE OR REPLACE FUNCTION zc_MI_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Master', 'Главный элемент' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Master');

CREATE OR REPLACE FUNCTION zc_MI_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Child', 'Подчиненный элемент' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Child');

CREATE OR REPLACE FUNCTION zc_MI_Detail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Detail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Detail', 'Подчиненный элемент (детали)' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Detail');

CREATE OR REPLACE FUNCTION zc_MI_Reserv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Reserv'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Reserv', 'Подчиненный элемент (резерв)' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Reserv');
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                        * 
*/
