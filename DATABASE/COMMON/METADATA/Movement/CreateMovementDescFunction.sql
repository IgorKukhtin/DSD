CREATE OR REPLACE FUNCTION zc_Movement_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Income', 'Приход' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Income');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionUnion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionUnion', 'Производство - смешивание' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion');

CREATE OR REPLACE FUNCTION zc_Movement_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Send', 'Перемещение' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Send');

CREATE OR REPLACE FUNCTION zc_Movement_SendOnPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendOnPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendOnPrice', 'Перемещение по цене' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendOnPrice');

CREATE OR REPLACE FUNCTION zc_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Sale', 'Продажа' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Sale');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnOut', 'Возврат поставщику' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.07.13                                        * add zc_Movement_SendOnPrice
 16.07.13                                        * НОВАЯ СХЕМА2 - Create and Insert
 30.06.13                                        * НОВАЯ СХЕМА
*/
