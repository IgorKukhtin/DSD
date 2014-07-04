CREATE OR REPLACE FUNCTION zc_Movement_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PriceList', 'Прайс-лист' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PriceList');

CREATE OR REPLACE FUNCTION zc_Movement_OrderExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderExternal', 'Заявки сторонние' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderExternal');

CREATE OR REPLACE FUNCTION zc_Movement_OrderInternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderInternal', 'Заявки внутренние' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderInternal');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.07.14                                                       * + zc_Movement_OrderInternal
 01.07.14                                                       *
*/
