--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDatePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDatePartner', 'Дата накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateMark', ' 	Дата маркировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark');

CREATE OR REPLACE FUNCTION zc_MovementDate_AccrualDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateMark', ' 	Дата маркировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark');

CREATE OR REPLACE FUNCTION zc_MovementDate_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_ServiceDate', ' 	Дата маркировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_ServiceDate');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.13         * add zc_MovementDate_ServiceDate
 01.08.13         * add zc_MovementDate_OperDateMark
 08.07.13                                        * НОВАЯ СХЕМА - Create and Insert
 30.06.13                                        * НОВАЯ СХЕМА
*/
