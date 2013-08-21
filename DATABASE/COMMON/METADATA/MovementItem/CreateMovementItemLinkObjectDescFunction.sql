-- CREATE OR REPLACE FUNCTION zc_MovementItemLink_Partion()
--   RETURNS integer AS
-- $BODY$BEGIN
--   RETURN 2;
-- END;  $BODY$ LANGUAGE PLPGSQL;


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


CREATE OR REPLACE FUNCTION zc_MILinkObject_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_MILinkObject_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_MILinkObject_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_MILinkObject_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_From', 'Откуда идет заправка' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_From');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Goods', 'Товар' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_MILinkObject_AmountNorm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_AmountNorm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_AmountNorm', 'Количество по норме' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_AmountNorm');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.13         * add zc_MILinkObject_From, zc_MILinkObject_Goods 
 30.06.13                                        * rename zc_MI...
 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * zc_MovementItemFloat_AmountPacker
*/
