CREATE OR REPLACE FUNCTION zc_MI_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Master', 'Главный элемент документа' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Master');

CREATE OR REPLACE FUNCTION zc_MI_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Child', 'Подчиненный элемент документа' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Child');

CREATE OR REPLACE FUNCTION zc_MI_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Sign', 'Элемент Электронная подпись' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Sign');

CREATE OR REPLACE FUNCTION zc_MI_Message() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Message', 'Элемент Сообщение' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Message');
  
CREATE OR REPLACE FUNCTION zc_MI_Second() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Second'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Second', 'Второй подчиненный элемент документа' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Second');

CREATE OR REPLACE FUNCTION zc_MI_Detail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Detail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Detail', 'Подчиненный элемент документа (детали)' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Detail');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.21         * zc_MI_Detail
 12.11.19                                                       * zc_MI_Second
 20.09.18         * zc_MI_Message
 23.08.16         * add zc_MI_Sign
 12.07.13                                        * НОВАЯ СХЕМА2
 30.06.13                                        * rename zc_MI...
 30.06.13                                        * НОВАЯ СХЕМА
*/
