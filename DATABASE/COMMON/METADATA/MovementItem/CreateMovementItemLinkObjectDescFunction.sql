-- CREATE OR REPLACE FUNCTION zc_MovementItemLink_Partion()
--   RETURNS integer AS
-- $BODY$BEGIN
--   RETURN 2;
-- END;  $BODY$ LANGUAGE plpgsql;


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


CREATE OR REPLACE FUNCTION zc_MovementItemLink_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MovementItemLink_GoodsKind'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemLink_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MovementItemLink_Asset'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemLink_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MovementItemLink_Receipt'); END; $BODY$ LANGUAGE plpgsql;


/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».

 29.06.13                                        * ÕŒ¬¿ﬂ —’≈Ã¿
 29.06.13                                        * zc_MovementItemFloat_AmountPacker
*/
