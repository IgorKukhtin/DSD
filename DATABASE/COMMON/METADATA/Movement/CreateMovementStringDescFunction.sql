--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberPartner', 'Номер накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner');

CREATE OR REPLACE FUNCTION zc_MovementString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_PartionGoods', 'Партия товара' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MovementString_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FileName', 'Имя файла' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName');

CREATE OR REPLACE FUNCTION zc_MovementString_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_OKPO', 'ОКПО' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.13         * add zc_MovementString_OKPO              
 12.08.13         * add zc_MovementString_FileName              
 19.07.13         * add zc_MovementString_PartionGoods()
 30.06.13                                        * НОВАЯ СХЕМА
*/
