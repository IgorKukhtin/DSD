CREATE OR REPLACE FUNCTION zc_MIDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Insert', 'Дата/время создания' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert');


CREATE OR REPLACE FUNCTION zc_MIDate_StartBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_StartBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_StartBegin', 'Дата/время начало' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_StartBegin');

CREATE OR REPLACE FUNCTION zc_MIDate_EndBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EndBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_EndBegin', 'Дата/время завершение' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EndBegin');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         * zc_MIDate_StartBegin
                    zc_MIDate_EndBegin
 28.08.20                                        * 
*/
