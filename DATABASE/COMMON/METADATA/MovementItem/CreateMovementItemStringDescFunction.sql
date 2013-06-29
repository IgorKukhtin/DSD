--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementItemString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MovementItemString_Comment'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MovementItemString_PartionGoods'); END; $BODY$ LANGUAGE plpgsql;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * zc_MovementItemString_PartionGoods
*/
