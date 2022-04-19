CREATE OR REPLACE FUNCTION zc_Movement_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Service', 'Начисление аренды' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Service');

CREATE OR REPLACE FUNCTION zc_Movement_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Cash', 'Касса' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Cash');

CREATE OR REPLACE FUNCTION zc_Movement_CashSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_CashSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_CashSend', 'Касса, движение денег' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_CashSend');
   
CREATE OR REPLACE FUNCTION zc_Movement_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Currency', 'Касса, движение денег' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Currency');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.22         * zc_Movement_Currency
 19.01.22         * zc_Movement_CashSend
 14.01.22         * zc_Movement_Service
 08.01.22                                        *
*/
