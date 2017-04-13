
CREATE OR REPLACE FUNCTION zc_MovementDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Insert', 'Дата/время создания' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert');

CREATE OR REPLACE FUNCTION zc_MovementDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Update', 'Дата/время корректировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDatePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDatePartner', 'Дата/время корректировки' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! РАСПОЛАГАЙТЕ ДЕСКИ ПО АЛФАВИТУ !!!!!!!!!!!!!!!!!!!
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.   Роман
13.04.17                                                         *
25.02.17                                        * start
*/
